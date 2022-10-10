# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit cmake

DESCRIPTION="Official Telegram messenger desktop client"
HOMEPAGE="https://telegram.org"



if [[ "$PV" == "9999" ]] ; then
	inherit git-r3
	KEYWORDS=""

	EGIT_REPO_URI="https://github.com/${PN}/tdesktop.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/telegramdesktop/${PN}/releases/download/v${PV}/${P}-full.tar.gz"
	S="${WORKDIR}/${P}-full"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	app-arch/lzma
	app-text/hunspell
	dev-cpp/range-v3
	dev-libs/openssl
	dev-libs/xxhash
	media-libs/openal
	media-libs/opus
	media-libs/rnnoise
	media-video/ffmpeg
	sys-libs/zlib
"

DEPEND="${RDEPEND}"

