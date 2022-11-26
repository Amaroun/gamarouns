# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit cmake

DESCRIPTION="Bayesian Collaborative Denoiser for Monte Carlo Rendering"
HOMEPAGE="https://perso.telecom-paristech.fr/boubek/papers/BCD/"

PATCHES="${FILESDIR}/bcd_system_deps-${PV}.patch"

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/superboubek/bcd"
else
	SRC_URI="https://github.com/superboubek/bcd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-cpp/eigen
	dev-cpp/json
	dev-libs/imath
	dev-libs/imath
	media-libs/openexr
	sys-libs/zlib
"
src_prepare() {

	rm -r "${S}/CMake"
	rm -r "${S}/ext"
	cmake_src_prepare
}
src_configure() {

local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE=True
		-DBCD_BUILD_GUI=OFF
		-DBCD_USE_CUDA=OFF
	)
	cmake_src_configure
}
src_install() {

	cmake_src_install
	insinto /usr/include/${PN}
	doins -r include/${PN}/core
	insinto /usr/share/${PN}/cmake
	newins ${FILESDIR}/FindBCD.cmake ${PN}-config.cmake
}
