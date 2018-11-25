# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit cmake-utils flag-o-matic versionator

DESCRIPTION="LuxCoreRender is a physically correct, unbiased rendering engine. It is built on physically based equations that model the transportation of light."
HOMEPAGE="http://www.luxcorerender.net"



if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/LuxCoreRender/LuxCore.git"
else
	SRC_URI="https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/${PN}_v${PV} -> ${P}.tar.gz"
fi


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opencl shared"

REQUIRED_USE="debug? ( shared )"

RDEPEND=">=dev-libs/boost-1.43:=
	media-gfx/openvdb
	dev-libs/c-blosc
	media-libs/openimageio
	media-libs/embree
	virtual/opengl
	opencl? ( virtual/opencl )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/LuxCore-${PN}_v${PV}"

PATCHES+=( 
        "${FILESDIR}/${PN}_system_openvdb.patch"
        "${FILESDIR}/${PN}_remove_openvdb_files_build.patch"
        )

src_prepare() {

	rm -r "${S}/deps/openvdb-3.1.0"
	cmake-utils_src_prepare

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


src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include
	doins -r include/luxcore
	doins -r include/slg
	doins -r include/luxrays
	doins -r deps/eos_portable_archive-v5.1/eos
	insinto /usr/include/luxcore
	doins ${BUILD_DIR}/generated/include/luxcore/cfg.h
	insinto /usr/include/luxrays
	doins ${BUILD_DIR}/generated/include/luxrays/cfg.h
	if use shared ; then
		dolib ${BUILD_DIR}/lib/libluxcore.so
		dolib ${BUILD_DIR}/lib/libslg-core.so
		dolib ${BUILD_DIR}/lib/libslg-film.so
		dolib ${BUILD_DIR}/lib/libslg-kernels.so
		dolib ${BUILD_DIR}/lib/libluxrays.so
	else
		dolib.a ${BUILD_DIR}/lib/libluxcore.a
		dolib.a ${BUILD_DIR}/lib/libslg-core.a
		dolib.a ${BUILD_DIR}/lib/libslg-film.a
		dolib.a ${BUILD_DIR}/lib/libslg-kernels.a
		dolib.a ${BUILD_DIR}/lib/libluxrays.a
	fi
}

