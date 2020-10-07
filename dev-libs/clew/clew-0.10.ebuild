# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="The OpenCL Extension Wrangler Library"
HOMEPAGE="https://github.com/martijnberger/clew"

inherit cmake-utils

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/martijnberger/clew.git"
else
	SRC_URI="https://github.com/martijnberger/clew/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

PATCHES+=(
	"${FILESDIR}/${P}_install_paths.patch"
        )


src_install() {
	cmake-utils_src_install
	insinto usr/share/${PN}/cmake
	newins ${FILESDIR}/Findclew.cmake ${PN}-config.cmake
}

