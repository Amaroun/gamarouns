# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit  cmake-utils
CMAKE_BUILD_TYPE="Release"

DESCRIPTION="Intel(R) Graphics Memory Management Library"
HOMEPAGE="https://github.com/intel/gmmlib"

LICENSE="MIT"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/gmmlib.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
#	SRC_URI="https://01.org/sites/default/files/${P}-source.tar.gz -> ${P}.tar.gz"
#	S=${WORKDIR}/Beignet-${PV}-Source
fi


src_prepare() {
	cmake-utils_src_prepare
}
src_configure() {

	cmake-utils_src_configure
}
src_install() {
	dolib.a "${BUILD_DIR}/Source/GmmLib/libigfxgmmumd.a"
	dolib.a "${BUILD_DIR}/Source/GmmLib/libigfx_gmmumd_excite.a"
	dolib.a "${BUILD_DIR}/Source/GmmLib/libgmm_umd.a"

	insinto "/usr/include"
	doins "${S}/Source/inc/portable_compiler.h"
	doins -r "${S}/Source/inc/common"
	doins -r "${S}/Source/inc/umKmInc"

	insinto "/usr/include"

	sed -i 's/..\/..\/inc\///' "${S}/Source/GmmLib/inc/GmmLib.h"
	doins "${S}/Source/GmmLib/inc/GmmLib.h"
	doins -r "${S}/Source/GmmLib/inc/External"
	doins -r "${S}/Source/GmmLib/inc/Internal"

}
