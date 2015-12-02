# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

DESCRIPTION="Embree ray tracing kernels by intel"
HOMEPAGE="https://embree.github.io"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ispc"

RDEPEND="
	ispc? ( dev-lang/ispc )
	dev-cpp/tbb
	"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=""
	if ispc; then
		mycmakeargs="${mycmakeargs} -DENABLE_ISPC_SUPPORT=ON"
	else
		mycmakeargs="${mycmakeargs} -DENABLE_ISPC_SUPPORT=OFF"
	fi
	mycmakeargs="${mycmakeargs}
		  -DCMAKE_INSTALL_PREFIX=/usr
		  -DCMAKE_BUILD_TYPE=Release
		  -DENABLE_TUTORIALS=OFF
		  -DTBB_ROOT=/usr"
	cmake-utils_src_configure
}

