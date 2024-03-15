# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit  cmake

CMAKE_BUILD_TYPE="Release"

DESCRIPTION="VLC-Qt is a free library used to connect Qt and libVLC libraries"
HOMEPAGE="https://github.com/vlc-qt/vlc-qt"

LICENSE="LGPL-3.0"
SLOT="0"

IUSE="qt5 qt6 X"

REQUIRED_USE=" ^^ ( qt5 qt6 ) "

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vlc-qt/vlc-qt.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86 ~arm  ~arm64"
	SRC_URI="https://github.com/vlc-qt/vlc-qt/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

RDEPEND="
	qt5? (
		>=dev-qt/qtcore-5.15:5
		>=dev-qt/qtdeclarative-5.15:5
	)
	qt6? (
		dev-qt/qtbase:6
		dev-qt/qtdeclarative:6
	)

	>=media-video/vlc-2.1
	"
PATCHES+=( "${FILESDIR}/${PN}-1.1.1_qt6.patch" )

src_configure()
{
	local mycmakeargs=( -DWITH_X11=$(usex X ON OFF) )

	use qt5 && mycmakeargs+=( -DQT_VERSION=5 )
	use qt6 && mycmakeargs+=( -DQT_VERSION=6 )

	cmake_src_configure
}
