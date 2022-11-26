# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Lightweight Spotify client using Qt"
HOMEPAGE="https://github.com/kraxarn/spotify-qt"
SRC_URI="https://github.com/kraxarn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+qt5 qt6"

REQUIRED_USE="^^ ( qt5 qt6 )"

QT_SLOT="5"
if [ use qt6 ] ; then
	QT_SLOT="6"
fi

RDEPEND="dev-qt/qtcore:${QT_SLOT}
	dev-qt/qtgui:${QT_SLOT}
	dev-qt/qtdbus:${QT_SLOT}
	dev-qt/qtnetwork:${QT_SLOT}
	dev-qt/qtsvg:${QT_SLOT}
	dev-qt/qtwidgets:${QT_SLOT}"
DEPEND="${RDEPEND}"

