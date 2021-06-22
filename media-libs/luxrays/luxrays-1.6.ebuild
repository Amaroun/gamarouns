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
else
	SRC_URI="https://codeload.github.com/LuxCoreRender/LuxCore/tar.gz/luxrender_v${PV} -> ${P}.tar.gz"

fi


LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64"
IUSE="debug opencl shared"

REQUIRED_USE="debug? ( shared )"

RDEPEND=">=dev-libs/boost-1.43:=
	media-libs/openimageio
	media-libs/embree
	virtual/opengl
	opencl? (
		dev-libs/clhpp
		virtual/opencl )"

DEPEND="${RDEPEND}"
S="${WORKDIR}/LuxCore-luxrender_v${PV}"

PATCHES+=(
	"${FILESDIR}/${PN}-${SLOT}_cmake_python.patch"
	"${FILESDIR}/${PN}-${SLOT}_cl2hpp.patch"
	"${FILESDIR}/${P}_up_to_date_cpp.patch"
	"${FILESDIR}/${P}_embree3.patch"
	"${FILESDIR}/${P}_kernel_preprocess.patch"
)
src_prepare() {

	CMAKE_REMOVE_MODULES=yes
	CMAKE_REMOVE_MODULES_LIST="FindOpenCL FindEmbree FindGLEW FindGLUT FindOpenEXR FindOpenImageIO"

	if use shared ; then
		epatch "${FILESDIR}/${PN}-shared_libs.patch"
	fi


	cmake-utils_src_prepare

	$(grep -Rwle 'cl2.hpp' | xargs sed -i 's|cl2\.hpp|opencl\.hpp|g')

}


src_configure() {
	append-flags -fPIC
        if use opencl ; then
		append-cppflags -DCL_HPP_CL_1_2_DEFAULT_BUILD -DCL_HPP_TARGET_OPENCL_VERSION=120 -DCL_HPP_MINIMUM_OPENCL_VERSION=120
	else
		append-cppflags -DLUXRAYS_DISABLE_OPENCL
	fi
	BoostPythons="$(equery u boost | grep -e 'python_targets_python[[:digit:]]_[[:digit:]]' | tr '\n' ';' | sed  -e 's/\([[:digit:]]\+\)_\([[:digit:]]\+\)/\1.\2/g'  -e 's/[+_\-]\+//g' -e 's;[[:alpha:]]\+;;g')"
	einfo "Boost python versions: $BoostPythons "
	mycmakeargs=( -DPythonVersions="${BoostPythons}")
	use opencl || mycmakeargs=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev -DPythonVersions="${BoostPythons}")
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make luxcore
	cmake-utils_src_make smallluxgpu
	cmake-utils_src_make luxrays
}

src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include/luxrays
	doins -r include/luxcore
	doins -r include/slg
	doins -r include/luxrays
	if use shared ; then
		newlib.so ${BUILD_DIR}/lib/libluxcore.so libluxcore-${SLOT}.so
		newlib.so ${BUILD_DIR}/lib/libsmallluxgpu.so libsmallluxgpu-${SLOT}.so
		newlib.so ${BUILD_DIR}/lib/libluxrays.so libluxrays-${SLOT}.so
	else
		newlib.a ${BUILD_DIR}/lib/libluxcore.a libluxcore-${SLOT}.a
		newlib.a ${BUILD_DIR}/lib/libsmallluxgpu.a libsmallluxgpu-${SLOT}.a
		newlib.a ${BUILD_DIR}/lib/libluxrays.a libluxrays-${SLOT}.a
	fi
}

