# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools user

DESCRIPTION="Tox plugin for Purple/Pidgin"
HOMEPAGE="https://tox.dhs.org"
SRC_URI="https://github.com/jin-eld/tox-prpl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""


RDEPEND="
	net-im/pidgin
	net-libs/tox
	sys-libs/ncurses:0=
	>=dev-libs/libsodium-0.6.1:=[asm,urandom]"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	"
PATCHES="${FILESDIR}/tox_callback_user_data_handling.patch"

src_prepare() {
	default
	eautoreconf
}

