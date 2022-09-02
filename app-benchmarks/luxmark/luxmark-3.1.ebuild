# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit cmake flag-o-matic desktop

DESCRIPTION="A GPL OpenCL Benchmark."
HOMEPAGE="http://www.luxmark.info"

SRC_URI="https://github.com/LuxCoreRender/LuxMark/archive/${PN}_v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 opencl scenes debug"

RDEPEND="
	 >=dev-libs/boost-1.43:=[python]
	media-libs/luxrays:=[debug=,opencl=]
	media-libs/openimageio
	virtual/opengl
	opencl? (
		virtual/opencl
		dev-libs/clhpp
		)
	media-libs/freeglut
	media-libs/glew
	app-benchmarks/luxmark-scenes:${SLOT}
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtnetwork
	dev-qt/qtopengl
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"
PATCHES+=( "${FILESDIR}/${PN}-qt5.patch" )

S="${WORKDIR}/LuxMark-${PN}_v${PV}"
src_prepare() {
        rm "${S}/cmake/Packages/FindOpenCL.cmake"
        rm "${S}/cmake/Packages/FindEmbree.cmake"
        rm "${S}/cmake/Packages/FindGLEW.cmake"
        rm "${S}/cmake/Packages/FindGLUT.cmake"
        rm "${S}/cmake/Packages/FindOpenEXR.cmake"

	cp "${FILESDIR}/FindOpenVDB.cmake" "${S}/cmake"

	PATCHES+=( "${FILESDIR}/${PN}-${PV}_link_stuff.patch" )

	if use debug ; then
		PATCHES+=( "${FILESDIR}/${P}_luxrays-shared.patch" )
	else
		PATCHES+=( "${FILESDIR}/${PN}-${SLOT}_luxrays_static.patch" )
	fi
	cmake_src_prepare

}

src_configure() {
	use cpu_flags_x86_sse && append-flags "-msse -DLUX_USE_SSE"
        use cpu_flags_x86_sse2 && append-flags "-msse2"

        if use debug ; then
		append-flags -ggdb
        fi

	local mycmakeargs=""
	mycmakeargs=("${mycmakeargs}
		  -DLUX_DOCUMENTATION=OFF
		  -DCMAKE_INSTALL_PREFIX=/usr")
        BoostPythons="$(equery u boost | grep -e 'python_targets_python[[:digit:]]_[[:digit:]]' | tr '\n' ';' | sed  -e 's/\([[:digit:]]\+\)_\([[:digit:]]\+\)/\1.\2/g'  -e 's/[+_\-]\+//g' -e 's;[[:alpha:]]\+;;g')"
        einfo "Boost python versions: $BoostPythons "
        mycmakeargs=( -DPythonVersions="${BoostPythons}")

	! use opencl && mycmakeargs=("${mycmakeargs}
		  -DLUXRAYS_DISABLE_OPENCL=ON")

	cmake_src_configure
}

src_install() {

	newbin "${BUILD_DIR}/bin/${PN}" "${PN}-${SLOT}"
	dodoc AUTHORS.txt
	newicon "${FILESDIR}/${PN}.svg" "${PN}-${SLOT}.svg"


	make_desktop_entry "${PN}-${SLOT}" "${PN}-${SLOT}" "${PN}-${SLOT}" "Utility" "Path=/usr/share/${PN}"

}
