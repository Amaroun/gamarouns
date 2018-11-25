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
	SRC_URI="https://github.com/LuxCoreRender/LuxMark/archive/${PN}_v${PV}.tar.gz
	https://raw.githubusercontent.com/pemryan/LuxRender/master/luxrender.svg"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 opencl -no_icon scenes debug"

RDEPEND=">=dev-libs/boost-1.43:=[python]
	media-libs/luxrender:=[debug=,opencl=]
	media-libs/openimageio
	virtual/opengl
	opencl? ( virtual/opencl )
	media-libs/freeglut
	media-libs/glew
	app-benchmarks/luxmark-scenes
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

src_prepare() {
	if use debug ; then
		PATCHES+=( "${FILESDIR}/${PN}-shared-luxrays.patch" )
	else
		PATCHES+=( "${FILESDIR}/${PN}-static-luxrays.patch" )
	fi
	cmake-utils_src_prepare

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

	local mycmakeargs=""
	mycmakeargs=("${mycmakeargs}
		  -DLUX_DOCUMENTATION=OFF
		  -DCMAKE_INSTALL_PREFIX=/usr")
	! use opencl && mycmakeargs=("${mycmakeargs}
		  -DLUXRAYS_DISABLE_OPENCL=ON")

	cmake-utils_src_configure
}

src_install() {

	dobin "${CMAKE_BUILD_DIR}"/bin/luxmark
	dodoc AUTHORS.txt || die
	if ! use no_icon ; then
		doicon ${DISTDIR}/luxrender.svg
	fi


	make_desktop_entry "${PN}" "${PN}" "luxrender" "Utility" "Path=/usr/share/${PN}"

}
