# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils flag-o-matic mercurial versionator

DESCRIPTION="A GPL OpenCL Benchmark."
HOMEPAGE="http://www.luxmark.info"
EHG_REPO_URI="https://bitbucket.org/luxrender/luxmark"

if [[ "$PV" == "9999" ]] ; then
	SRC_URI="https://bytebucket.org/luxrender/lux/raw/tip/luxrender.svg"
else
	VER_MAJ_MIN="$(get_version_component_range 1-2)"
	EHG_REVISION="${PN}_v${VER_MAJ_MIN}"
	SRC_URI="https://bytebucket.org/luxrender/lux/raw/203f2dad3260679802868560f1dac3c9bfee51a1/luxrender.svg"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 opencl -no_icon scenes debug"

RDEPEND=">=dev-libs/boost-1.43:=[python]
	media-libs/luxrays:=[debug?,opencl=]
	media-libs/openimageio
	virtual/opengl
	virtual/opencl
	media-libs/freeglut
	media-libs/glew
	app-benchmarks/luxmark-scenes
        dev-qt/qtcore:4
        dev-qt/qtgui:4
        dev-qt/qtnetwork:4
        dev-qt/qtopengl:4
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"

src_prepare() {
	epatch "${FILESDIR}/${PN}-slg_renderengine_h_location.patch"
}

src_configure() {
	use cpu_flags_x86_sse && append-flags "-msse -DLUX_USE_SSE"
        use cpu_flags_x86_sse2 && append-flags "-msse2"

	use debug && append-flags -ggdb
	local mycmakeargs=""
	mycmakeargs=("${mycmakeargs}
		  -DLUX_DOCUMENTATION=OFF
		  -DCMAKE_INSTALL_PREFIX=/usr")

       !use opencl && mycmakeargs=("${mycmakeargs}
                  -DLUXRAYS_DISABLE_OPENCL=ON")

	cmake-utils_src_configure
}

src_install() {
#	cmake-utils_src_install
	dobin "${CMAKE_BUILD_DIR}"/bin/luxmark
	dodoc AUTHORS.txt || die

	doicon ${DISTDIR}/luxrender.svg


	make_desktop_entry "${PN}" "${PN}" "luxrender" "Utility" "Path=/usr/share/${PN}"

}
