# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils

DESCRIPTION="Embree ray tracing kernels by intel"
HOMEPAGE="https://embree.github.io"

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/embree/embree.git"
else
	SRC_URI="https://github.com/embree/embree/tar.ga/v${PV} -> ${P}.tar.gz"
fi


LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ispc +tbb tutorial bvh_extension"

RDEPEND="
	ispc? ( dev-lang/ispc )
	tbb? ( dev-cpp/tbb )
	"
DEPEND="${RDEPEND}"


src_configure() {
	local mycmakeargs=()
	if use ispc; then
		mycmakeargs+=("-DEMBREE_ISPC_SUPPORT=ON")
	else
		mycmakeargs+=("-DEMBREE_ISPC_SUPPORT=OFF")
	fi
	if use tbb; then
		mycmakeargs+=("-DEMBREE_TASKING_SYSTEM=TBB")
	else
		mycmakeargs+=("-DEMBREE_TASKING_SYSTEM=INTERNAL")
	fi
	if use tutorial; then
		mycmakeargs+=("-DENABLE_TUTORIALS=ON")
	else
		mycmakeargs+=("-DENABLE_TUTORIALS=OFF")
	fi

	mycmakeargs+=("-DCMAKE_INSTALL_PREFIX=/usr"
			"-DCMAKE_BUILD_TYPE=Release"
			"-DTBB_ROOT=/usr")
	cmake-utils_src_configure
}

