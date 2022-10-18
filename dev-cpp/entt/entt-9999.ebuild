# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="EnTT is a header-only, tiny and easy to use library for game programming and much more written in modern C++."
HOMEPAGE="https://github.com/skypjack/entt"

EGIT_REPO_URI="https://github.com/skypjack/entt.git"
EGIT_CLONE_TYPE="shallow"

if [[ "${PV}" != 9999 ]]; then
	COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"
