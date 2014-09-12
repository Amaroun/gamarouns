
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="4"

DESCRIPTION="C++ header-only serialization library"
HOMEPAGE="http://www.antisphere.com/Wiki/tools:anttweakbar?sb=tools"

SRC_URI="https://codeload.github.com/USCiLab/cereal/tar.gz/v1.0.0 -> ${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="$DEPEND"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
}

#src_compile() {
#	cd src
#	emake || die "${P} could not be compiled"
#}

src_install() {
	insinto /usr/include
	doins -r include/*
}
