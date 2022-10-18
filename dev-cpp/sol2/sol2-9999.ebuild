# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="sol2 is a C++ library binding to Lua"
HOMEPAGE="https://github.com/ThePhD/sol2"

EGIT_REPO_URI="https://github.com/ThePhD/sol2.git"
EGIT_CLONE_TYPE="shallow"

if [[ "${PV}" != 9999 ]]; then
	COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"
