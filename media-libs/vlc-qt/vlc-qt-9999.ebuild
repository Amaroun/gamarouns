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

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vlc-qt/vlc-qt.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86 ~arm  ~arm64"
	SRC_URI="https://github.com/vlc-qt/vlc-qt/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

RDEPEND=">=dev-qt/qtcore-5.5
	>=media-video/vlc-2.1
	"
DEPEND="${REDEPEND}
	>=dev-util/cmake-3.0.2"
