
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="4"

DESCRIPTION="C++ header-only serialization library"
HOMEPAGE="http://uscilab.github.io/cereal/"

SRC_URI="https://codeload.github.com/USCiLab/cereal/tar.gz/v${PV} -> ${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="$DEPEND"

src_unpack() {
	unpack ${A}
}

src_install() {
	insinto /usr/include
	doins -r include/*
}
