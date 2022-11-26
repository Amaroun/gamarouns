# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="LuxCoreRender is a physically correct, unbiased rendering engine. It is built on physically based equations that model the transportation of light."
HOMEPAGE="http://www.luxcorerender.net"



if [[ "$PV" == "9999" ]] ; then
	inherit git-r3
	KEYWORDS=""

	EGIT_REPO_URI="https://github.com/LuxCoreRender/LuxCore.git"
	S="${WORKDIR}/LuxCore-${PN}_v${PV}"
else
	KEYWORDS="~amd64 ~x86"
	DV=${PV//_alpha/alpha}
	DV=${DV//_beta/beta}
	SRC_URI="https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/${PN}_v${DV} -> ${P}.tar.gz"
	S="${WORKDIR}/LuxCore-${PN}_v${DV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug opencl cuda shared"

REQUIRED_USE="debug? ( shared )"

RDEPEND="dev-libs/boost:=[numpy]
	media-gfx/openvdb
	dev-cpp/json
	dev-cpp/robin-hood-hashing
	dev-libs/c-blosc
	dev-libs/clew
	dev-libs/cuew
	dev-libs/spdlog
	media-libs/bcd
	media-libs/embree
	media-libs/lut
	media-libs/oidn
	media-libs/opencv[cuda?]
	media-libs/openimageio
	media-libs/opensubdiv
	virtual/opengl
	opencl? ( virtual/opencl )"

DEPEND="${RDEPEND}"


PATCHES+=(
	"${FILESDIR}/${P}_system_deps.patch"
	"${FILESDIR}/${P}_code_updates.patch"
        )

src_prepare() {

	cmake_src_prepare

	rm -r "${S}/deps"
	rm -r "${S}/samples/luxcoreui/deps"
	rm -r "${S}/cmake/Packages"
	cp -r "${FILESDIR}/Packages" "${S}/cmake/"

}
src_configure() {

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_POSITION_INDEPENDENT_CODE=True )

	if use debug ; then
		 append-flags -ggdb
		CMAKE_BUILD_TYPE="Debug"
	fi
	use opencl || mycmakeargs+=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev )
	use cuda || mycmakeargs+=( -DLUXRAYS_DISABLE_CUDA=ON)
	use shared && mycmakeargs+=( -DBUILD_LUXCORE_DLL=ON )
	cmake_src_configure
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
		dolib.a ${BUILD_DIR}/lib/libluxrays.a
	else
		dolib.a ${BUILD_DIR}/lib/libluxcore.a
		dolib.a ${BUILD_DIR}/lib/libslg-core.a
		dolib.a ${BUILD_DIR}/lib/libslg-film.a
		dolib.a ${BUILD_DIR}/lib/libslg-kernels.a
		dolib.a ${BUILD_DIR}/lib/libluxrays.a
	fi
}
