# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit cmake flag-o-matic

DESCRIPTION="LuxCoreRender is a physically correct, unbiased rendering engine. It is built on physically based equations that model the transportation of light."
HOMEPAGE="http://www.luxcorerender.net"

if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/LuxCoreRender/LuxCore.git"
else
	SRC_URI="https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/luxrender_v${PV} -> ${P}.tar.gz"

fi


LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64"
IUSE="debug luxcoreui opencl opengl openmp python samples shared"

REQUIRED_USE="debug? ( shared )"

RDEPEND="dev-libs/boost:=
	media-libs/openimageio
	media-libs/openexr
	media-libs/embree
	media-libs/libpng
	media-libs/tiff
	virtual/jpeg
	samples? (
		virtual/opengl
		media-libs/freeglut
		>=media-libs/glfw-3.0.0
		)
	luxcoreui?
		(
		media-libs/imgui
		dev-libs/nativefiledialog-extended
		)
	opencl? (
		dev-libs/clhpp
		virtual/opencl )"


DEPEND="${RDEPEND}"

BDEPEND="sys-devel/flex
	sys-devel/bison"

S="${WORKDIR}/LuxCore-luxrender_v${PV}"

#	"${FILESDIR}/${P}_system_deps.patch"

PATCHES+=(
	"${FILESDIR}/${P}_system_deps.patch"
	"${FILESDIR}/${P}_cl2hpp.patch"
	"${FILESDIR}/${P}_up_to_date_cpp.patch"
	"${FILESDIR}/${P}_embree3.patch"
	"${FILESDIR}/${P}_kernel_preprocess.patch"
	"${FILESDIR}/${P}_Imath.patch"
	"${FILESDIR}/${P}_boost_python_bindings.patch"
	"${FILESDIR}/${P}_luxcoreui_deps.patch"
)

src_prepare() {

	rm -r "${S}/cmake/Packages"
	rm -r "${S}/samples/luxcoreui/deps"
	if use shared ; then
		#chage libraries to shared
		grep ${S} -ilRe '\(add_library[(][^ ]*[ ]*\)STATIC' | xargs sed -i -e 's/\(add_library[\(][^ ]*[ ]*\)STATIC/\1SHARED/g'
		PATCHES+=( "${FILESDIR}/${P}_shared_libs.patch" )
	fi

	cmake_src_prepare
#}
#post() {
	#rename libraries for slotting with luxcorerender
	grep ${S} -ilRe 'add_\(library\|executable\)[(]\([^ ]*[ )]\)' | xargs sed -i -e 's/\(add_\(library\|executable\)[\(]\)\([^ ]*\)/\1luxrays-\3/g'
	grep ${S} -ilRe 'target_link_libraries[(]\([^ ]*\([ )]\|$\)\)' | xargs sed -i -e 's/\(target_link_libraries[(]\)\([^\s]*\)/\1luxrays-\2/gi'
	grep ${S} -ilRe 'set_target_properties[(]' |xargs sed -i -e 's/\(set_target_properties[(]\)\([^ ]*\)/\1luxrays-\2/gi'
	#put renamed libraries into link targets
	grep ${S} -ilRe 'target_link_libraries[(]' |xargs sed -i -e's/\(target_link_libraries[(][^ ]*[ ]*.*\)\([ ]\)\(luxrays[ ]\)/\1\2luxrays-\3/ig'
	grep ${S} -ilRe 'target_link_libraries[(]' |xargs sed -i -e's/\(target_link_libraries[(][^ ]*[ ]*.*\)\([ ]\)\(luxcore[ ]\)/\1\2luxrays-\3/ig'
	grep ${S} -ilRe 'target_link_libraries[(]' |xargs sed -i -e's/\(target_link_libraries[(][^ ]*[ ]*.*\)\([ ]\)\(smallluxgpu[ ]\)/\1\2luxrays-\3/ig'
	$(grep -Rwle 'cl2.hpp' | xargs sed -i 's|cl2\.hpp|opencl\.hpp|g')
}


src_configure() {
	append-flags -fPIC
        if use opencl ; then
		append-cppflags -DCL_HPP_CL_2_2_DEFAULT_BUILD -DCL_HPP_TARGET_OPENCL_VERSION=220 -DCL_HPP_MINIMUM_OPENCL_VERSION=220
	else
		append-cppflags -DLUXRAYS_DISABLE_OPENCL
	fi
	BoostPythons="$(equery u boost | grep -e 'python_targets_python[[:digit:]]_[[:digit:]]' | tr '\n' ';' | sed  -e 's/\([[:digit:]]\+\)_\([[:digit:]]\+\)/\1.\2/g'  -e 's/[+_\-]\+//g' -e 's;[[:alpha:]]\+;;g')"
	einfo "Boost python versions: $BoostPythons "
	local mycmakeargs=(
		-DLUXRAYS_SAMPLES=$(usex samples)
		-DLUXRAYS_LUXCOREUI=$(usex samples)
		-DLUXRAYS_OPENMP=$(usex openmp)
		-DLUXRAYS_PYTHON=$(usex python)
	)

	mycmakeargs+=( -DPythonVersions="${BoostPythons}")
	use opencl || mycmakeargs=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev -DPythonVersions="${BoostPythons}")
	cmake_src_configure
}

src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include/luxrays
	doins -r include/luxcore
	doins -r include/slg
	doins -r include/luxrays

	local LIB_TYPE=""
	if use shared ; then
		LIB_TYPE=".so"
#		dolib.so ${BUILD_DIR}/lib/libluxrays-luxcore.so
#		dolib.so ${BUILD_DIR}/lib/libluxrays-smallluxgpu.so
#		dolib.so ${BUILD_DIR}/lib/libluxrays-luxrays.so
	else
		LIB_TYPE=".a"
#		dolib.a ${BUILD_DIR}/lib/libluxrays-luxcore.a
#		dolib.a ${BUILD_DIR}/lib/libluxrays-smallluxgpu.a
#		dolib.a ${BUILD_DIR}/lib/libluxrays-luxrays.a
	fi

	dolib${LIB_TYPE} ${BUILD_DIR}/lib/libluxrays-luxrays${LIB_TYPE}
	dolib${LIB_TYPE} ${BUILD_DIR}/lib/libluxrays-luxcore${LIB_TYPE}
	dolib${LIB_TYPE} ${BUILD_DIR}/lib/libluxrays-smallluxgpu${LIB_TYPE}

	if use python ; then
		dolib.so ${BUILD_DIR}/lib/luxrays-pyluxcore.so
	fi

	if use samples ; then
		dobin ${BUILD_DIR}/bin/*
	fi
}

