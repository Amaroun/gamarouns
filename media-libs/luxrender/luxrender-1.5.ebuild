# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit cmake-utils flag-o-matic versionator

DESCRIPTION="LuxCoreRender is a physically correct, unbiased rendering engine. It is built on physically based equations that model the transportation of light."
HOMEPAGE="http://www.luxcorerender.net"


get_revision_url(){
	local relevant_versions_count=0
	for i in $(get_all_version_components) ; do
		if [[ "." == "$i" ]] ; then
			continue
		fi
		if [[ "-" == "$i" ]] ; then
			break
		fi
		if [[ "_" == "$i" ]] ; then
			break
		fi
		(( relevant_versions_count++ ))
	done

	local last_revision="$(get_version_component_range $"relevant_versions_count")"

	case "$last_revision" in
	m)
		echo "https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/luxmark_v$(get_version_component_range 1-$(( --relevant_versions_count ))) -> ${P}.tar.gz"
		;;
	*)
		echo "https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/luxrender_v$(get_version_component_range 1-${relevant_versions_count}) -> ${P}.tar.gz"
		;;
	esac

	return 0

}

if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/LuxCoreRender/LuxCore.git"
else
	SRC_URI="$(get_revision_url)"
	einfo "$SRC_URI"
fi


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opencl shared"

REQUIRED_USE="debug? ( shared )"

RDEPEND=">=dev-libs/boost-1.43:=
	media-libs/openimageio
	media-libs/embree
	virtual/opengl
	opencl? ( virtual/opencl )"

DEPEND="${RDEPEND}"

src_prepare() {

	if use shared ; then
		epatch "${FILESDIR}/${PN}-shared_libs.patch"
	fi
	epatch "${FILESDIR}/${PN}-sanitize_filename_zerochar.patch"

	default
}


src_configure() {
	append-flags -fPIC
        use opencl || append-flags -DLUXRAYS_DISABLE_OPENCL
	if use debug ; then
		 append-flags -ggdb
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	use opencl || mycmakeargs=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make luxcore
	cmake-utils_src_make smallluxgpu
	cmake-utils_src_make luxrays
}

src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include
	doins -r include/luxcore
	doins -r include/slg
	doins -r include/luxrays
	if use shared ; then
		dolib ${BUILD_DIR}/lib/libluxcore.so
		dolib ${BUILD_DIR}/lib/libsmallluxgpu.so
		dolib ${BUILD_DIR}/lib/libluxrays.so
	else
		dolib.a ${BUILD_DIR}/lib/libluxcore.a
		dolib.a ${BUILD_DIR}/lib/libsmallluxgpu.a
		dolib.a ${BUILD_DIR}/lib/libluxrays.a
	fi
}

