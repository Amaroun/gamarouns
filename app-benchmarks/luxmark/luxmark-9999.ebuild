# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils flag-o-matic mercurial 
#python-single-r1

DESCRIPTION="A GPL OpenCL Benchmark."
HOMEPAGE="http://www.luxmark.info"
EHG_REPO_URI="https://bitbucket.org/luxrender/luxmark"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 debug"

RDEPEND=">=dev-libs/boost-1.43[python]
	media-libs/openexr
	media-libs/tiff:=
	media-libs/libpng:=
	media-libs/libjpeg-turbo
	media-libs/ilmbase
	>=media-libs/freeimage-3.15.0
	media-libs/openimageio
	media-libs/slg
	media-libs/luxcore
	virtual/opengl
	virtual/opencl"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	~media-libs/luxrays-${PV}[debug?]"

#	doc? ( >=app-doc/doxygen-1.5.7[-nodot] )"
#PDEPEND="blender? ( =media-plugins/luxblend25-${PV} )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-slg_renderengine_h_location.patch"
}

src_configure() {
#	python-single-r1_pkg_setup
	use cpu_flags_x86_sse && append-flags "-msse -DLUX_USE_SSE"
        use cpu_flags_x86_sse2 && append-flags "-msse2"

	use debug && append-flags -ggdb
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		  -DLUX_DOCUMENTATION=OFF
		  -DLUXRAYS_DISABLE_OPENCL=OFF
		  -DCMAKE_INSTALL_PREFIX=/usr"
	cmake-utils_src_configure
}

src_install() {
#	cmake-utils_src_install
	dobin "${CMAKE_BUILD_DIR}"/bin/luxmark
	dodoc AUTHORS.txt || die

	# installing API(s) docs
#	if use doc; then
#		pushd "${S}"/doxygen > /dev/null
#		doxygen doxygen.template
#		dohtml html/* || die "Couldn't install API docs"
#		popd > /dev/null
#	fi

}
