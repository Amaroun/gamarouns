# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

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
		dev-cpp/clhpp
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
        rm -r "${S}/cmake/Packages"

	PATCHES+=(
			"${FILESDIR}/${PN}-${PV}_link_stuff.patch"
			"${FILESDIR}/${PN}-${PV}_boost_matching_python.patch"
		)

	cmake_src_prepare
}

src_configure() {
	use cpu_flags_x86_sse && append-flags "-msse -DLUX_USE_SSE"
        use cpu_flags_x86_sse2 && append-flags "-msse2"

        if use debug ; then
		append-flags -ggdb
        fi

        if use opencl ; then
                append-cppflags -DCL_HPP_CL_2_2_DEFAULT_BUILD -DCL_HPP_TARGET_OPENCL_VERSION=220 -DCL_HPP_MINIMUM_OPENCL_VERSION=220
        else
                append-cppflags -DLUXRAYS_DISABLE_OPENCL
        fi

        BoostPythons="$(equery u boost | grep -e 'python_targets_python[[:digit:]]_[[:digit:]]' | tr '\n' ';' | sed  -e 's/\([[:digit:]]\+\)_\([[:digit:]]\+\)/\1.\2/g'  -e 's/[+_\-]\+//g' -e 's;[[:alpha:]]\+;;g')"
        einfo "Boost python versions: $BoostPythons "
        mycmakeargs+=( -DPythonVersions="${BoostPythons}")

	mycmakeargs+=( -DLUX_DOCUMENTATION=OFF)

	cmake_src_configure
}

src_install() {

	newbin "${BUILD_DIR}/bin/${PN}" "${PN}-${SLOT}"
	dodoc AUTHORS.txt
	newicon "${FILESDIR}/${PN}.svg" "${PN}-${SLOT}.svg"


	make_desktop_entry "${PN}-${SLOT}" "${PN}-${SLOT}" "${PN}-${SLOT}" "Utility" "Path=/usr/share/${PN}"

}
