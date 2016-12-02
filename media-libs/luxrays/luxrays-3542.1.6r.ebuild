# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils mercurial flag-o-matic versionator

DESCRIPTION="Library to accelerate the ray intersection process by using GPUs"
HOMEPAGE="http://www.luxrender.net"
EHG_REPO_URI="https://bitbucket.org/luxrender/luxrays"


get_hg_revision(){
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
		echo "luxmark_v$(get_version_component_range 2-$((--relevant_versions_count )))"
		;;
	r)
		echo "luxrender_v$(get_version_component_range 2-$((--relevant_versions_count )))"
		;;
	*)
		echo "$(get_version_component_range 1)"
		;;
	esac

	return 0

}

if [[ "$PV" == "9999" ]] ; then
	SRC_URI="https://bytebucket.org/luxrender/lux/raw/tip/luxrender.svg"
else
	EHG_REVISION="$(get_hg_revision)"
fi


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opencl"

DEPEND=">=dev-libs/boost-1.43:=
	media-libs/openimageio
	media-libs/embree
	virtual/opengl
	opencl? ( virtual/opencl )"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	einfo "Using revision ${EHG_REVISION}"
	epatch "${FILESDIR}/${PN}-no_math_function_defines.patch"
}

src_configure() {
	append-flags -fPIC
        use opencl || append-flags -DLUXRAYS_DISABLE_OPENCL
	use debug && append-flags -ggdb

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

	dolib.a lib/libluxcore.a
	dolib.a lib/libsmallluxgpu.a
	dolib.a lib/libluxrays.a
}

