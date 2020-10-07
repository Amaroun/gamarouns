# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit cmake-utils

DESCRIPTION="Bayesian Collaborative Denoiser for Monte Carlo Rendering"
HOMEPAGE="https://perso.telecom-paristech.fr/boubek/papers/BCD/"

PATCHES="${FILESDIR}/bcd_system_deps.patch"

if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/superboubek/bcd"
else
	SRC_URI="https://github.com/superboubek/bcd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {

	rm "${S}/CMake/FindZlib.cmake"
	cp "${FILESDIR}/FindOpenEXR.cmake" "${S}/CMake"
	cmake-utils_src_prepare

}
src_configure() {

local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE=True
	)
	cmake-utils_src_configure
}
src_install() {

	cmake-utils_src_install
	insinto /usr/include/${PN}
	doins -r include/${PN}/core
	insinto /usr/share/${PN}/cmake
	newins ${FILESDIR}/FindBCD.cmake ${PN}-config.cmake
}
