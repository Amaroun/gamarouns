# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="7"

DESCRIPTION="A library that adds an easy GUI into OpenGL applications to interactively tweak them on-screen"
HOMEPAGE="http://www.antisphere.com/Wiki/tools:anttweakbar?sb=tools"

SRC_URI="http://freefr.dl.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip -> ${P}.zip"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
LICENSE="ZLIB"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="$DEPEND"

S="${WORKDIR}/AntTweakBar"


src_prepare() {
	default
	mkdir "$(get_libdir)"
	sed src/Makefile -i -e  "s/\.\.\/lib/\.\.\/$(get_libdir)/g"
	sed src/Makefile.osx -i -e "s/\.\.\/lib/\.\.\/$(get_libdir)/g"
}

src_compile() {
	cd src
	emake || die "${P} could not be compiled"
}

src_install() {
	dolib.so $(get_libdir)/libAntTweakBar.so
	dolib.so $(get_libdir)/libAntTweakBar.so.1
	insinto /usr/include
	doins include/AntTweakBar.h
}
