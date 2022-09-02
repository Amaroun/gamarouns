# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit scons-utils eutils

DESCRIPTION="A joystick testing and configuration tool for Linux"
HOMEPAGE="https://jstest-gtk.gitlab.io/"

LICENSE="GPLv3"
SLOT="0"

KEYWORDS="~amd64"
SRC_URI="https://github.com/Grumbel/jstest-gtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="dev-libs/libsigc++
	dev-cpp/gtkmm
	~x11-libs/gtkglext-1.2.0:="
HDEPEND="${RDEPEND}
	dev-util/sconf"

src_prepare(){
	epatch "${FILESDIR}/sconstruct_cxx11.patch"
	epatch "${FILESDIR}/sconstruct_unistd.patch"
	sed -i 's/gtkglextmm-1.2/gtkglext-1.0/' SConstruct || die "sed gtkglext version failed"
	local quotedCxxFlags
	local commaString = ""
	for cxxFlag in $CXXFLAGS
	do
		quotedCxxFlags="${quotedCxxFlags} ${commaString} \\\"${cxxFlag}\\\""
		commaString=", "
	done
	sed -i "s/CXXFLAGS=\[/CXXFLAGS=[${quotedCxxFlags},\ /" SConstruct || die "sed cxx flags failed"
#strangly enough, the gtkglext-1.2 installed by ::gentoo if found only as gtkglext-1.0
	sed -i 's/gtkglext-1.2/gtkglext-1.0/' SConstruct || die "sed gtkglext version failed"
	default
}
src_compile() {
	escons
}
src_install() {
	dobin "${S}/${PN}"
	insinto "/usr/share/${PN}"
	doins -r "${S}"/data

	doicon ${S}/data/generic.png
#	escons DESTDIR="${D}" install
	make_desktop_entry "${PN}" "${PN}" "generic" "Utility" "Path=/usr/share/${PN}"

}
