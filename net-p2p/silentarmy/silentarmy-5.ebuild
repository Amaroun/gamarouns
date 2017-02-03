# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6


#inherit

DESCRIPTION="Free open source Zcash miner for Linux with multi-GPU and Stratum support"
HOMEPAGE="https://github.com/mbevand/silentarmy"

LICENSE="MIT"
SLOT="0/5"



if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/mbevand/silentarmy.git -> ${P}.tar.gz"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://codeload.github.com/mbevand/silentarmy/tar.gz/v${PV} -> ${P}.tar.gz"
fi

src_install() {
	dobin "${S}/silentarmy"
	dobin "${S}/sa-solver"
}

