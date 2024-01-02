# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="JSON for modern C++"
HOMEPAGE="https://nlohmann.github.io/json/"

inherit cmake

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nlohmann/json.git"
else
	SRC_URI="https://github.com/nlohmann/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

