# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit cmake flag-o-matic desktop

DESCRIPTION="A GPL OpenCL Benchmark."
HOMEPAGE="http://www.luxmark.info"

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3
else
	DV=${PV//_alpha/alpha}
	SRC_URI="https://github.com/LuxCoreRender/LuxMark/archive/${PN}_v${DV}.tar.gz"
	S="${WORKDIR}/LuxMark-${PN}_v${DV}"
fi

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 opencl scenes debug"


RDEPEND="dev-libs/boost:=[python]
	dev-libs/clew
	media-libs/luxcorerender:=[debug=,opencl=]
	media-libs/openimageio
	media-libs/oidn
	virtual/opengl
	opencl? (
		virtual/opencl
		dev-cpp/clhpp
		)
	media-libs/freeglut
	media-libs/glew
	media-libs/embree
	app-benchmarks/luxmark-scenes:4
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtnetwork
	dev-qt/qtopengl
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"

PATCHES+=(
	"${FILESDIR}/${P}_system_deps.patch"
	)

src_prepare() {
#	if use debug ; then
#		PATCHES+=( "${FILESDIR}/${P}_luxcorerender_shared.patch" )
#	else
#		PATCHES+=( "${FILESDIR}/${P}_luxcorerender_static.patch" )
#	fi
	rm -r "${S}/cmake/Packages"
	cp -r "${FILESDIR}/Packages" "${S}/cmake"

	cmake_src_prepare

}

src_configure() {
	use cpu_flags_x86_sse && append-flags "-msse -DLUX_USE_SSE"
        use cpu_flags_x86_sse2 && append-flags "-msse2"

        if use debug ; then
		append-flags -ggdb
		CMAKE_BUILD_TYPE="Debug"
        else
		CMAKE_BUILD_TYPE="Release"
        fi
	BoostPythons="$(equery u boost | grep -e 'python_targets_python[[:digit:]]_[[:digit:]]' | tr '\n' ';' | sed  -e 's/\([[:digit:]]\+\)_\([[:digit:]]\+\)/\1.\2/g'  -e 's/[+_\-]\+//g' -e 's;[[:alpha:]]\+;;g')"
	einfo "Boost python versions: $BoostPythons "
	mycmakeargs=( "-DPythonVersions=${BoostPythons}")

	mycmakeargs+=("-DCMAKE_AUTOMOC=OFF")
	mycmakeargs+=("-DCMAKE_INSTALL_PREFIX=/usr")
	use opencl || mycmakeargs+=("-DLUXRAYS_DISABLE_OPENCL=ON")
	cmake_src_configure
}

src_install() {

	newbin "${BUILD_DIR}/bin/luxmark" "luxmark-${SLOT}"
	dodoc AUTHORS.txt || die
	newicon "${FILESDIR}/${PN}.svg" "${PN}-${SLOT}.svg"


	make_desktop_entry "${PN}-${SLOT}" "${PN}-${SLOT}" "${PN}-${SLOT}" "Utility" "Path=/usr/share/${PN}"

}
