# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit cmake-utils flag-o-matic

DESCRIPTION="LuxCoreRender is a physically correct, unbiased rendering engine. It is built on physically based equations that model the transportation of light."
HOMEPAGE="http://www.luxcorerender.net"



if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/LuxCoreRender/LuxCore.git"
	S="${WORKDIR}/LuxCore-${PN}_v${PV}"
else
	DV=$(ver_rs 3 '')
	SRC_URI="https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/${PN}_v${DV} -> ${P}.tar.gz"
	S="${WORKDIR}/LuxCore-${PN}_v${DV}"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opencl shared -eos-archive"

REQUIRED_USE="debug? ( shared )"

RDEPEND=">=dev-libs/boost-1.63:=
	eos-archive? ( dev-libs/eos-portable-archive )
	media-gfx/openvdb
	dev-libs/c-blosc
	media-libs/openimageio
	media-libs/embree
	media-libs/bcd
	virtual/opengl
	opencl? ( virtual/opencl )"

DEPEND="${RDEPEND}"


PATCHES+=(
        "${FILESDIR}/${PN}_python.patch"
        "${FILESDIR}/${PN}_system_deps.patch"
        "${FILESDIR}/${PN}_system_bcd.patch"
        )

src_prepare() {

	rm -r "${S}/deps"
	cp "${FILESDIR}/FindOpenVDB.cmake" "${S}/cmake"
	cp "${FILESDIR}/FindBCD.cmake" "${S}/cmake"

	if use shared ; then
		PATCHES+=(
			"${FILESDIR}/${PN}_build_shared.patch"
		)
	fi
	if ! use eos-archive ; then
		PATCHES+=(
			"${FILESDIR}/${PN}-2.2_boost_serialization.patch"
		)
	fi

	cmake-utils_src_prepare

}
src_configure() {

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_POSITION_INDEPENDENT_CODE=True )

	if use debug ; then
		 append-flags -ggdb
		CMAKE_BUILD_TYPE="Debug"
	fi
	use opencl || mycmakeargs+=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev )
	use shared && mycmakeargs+=( -DBUILD_LUXCORE_DLL=ON )
	cmake-utils_src_configure
}


src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include
	doheader -r include/luxcore
	doheader -r include/slg
	doheader -r include/luxrays
	doheader -r ${BUILD_DIR}/generated/include/luxcore
	doheader -r ${BUILD_DIR}/generated/include/luxrays
	if use shared ; then
		dolib.so ${BUILD_DIR}/lib/libluxcore.so
		dolib.a ${BUILD_DIR}/lib/libslg-core.a
		dolib.a ${BUILD_DIR}/lib/libslg-film.a
		dolib.a ${BUILD_DIR}/lib/libslg-kernels.a
		dolib.so ${BUILD_DIR}/lib/libluxrays.so
	else
		dolib.a ${BUILD_DIR}/lib/libluxcore.a
		dolib.a ${BUILD_DIR}/lib/libslg-core.a
		dolib.a ${BUILD_DIR}/lib/libslg-film.a
		dolib.a ${BUILD_DIR}/lib/libslg-kernels.a
		dolib.a ${BUILD_DIR}/lib/libluxrays.a
	fi
}

