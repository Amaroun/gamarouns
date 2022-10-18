# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Catch2 is mainly a unit testing framework for C++"
HOMEPAGE="https://github.com/catchorg/Catch2"

EGIT_REPO_URI="https://github.com/catchorg/${PN}.git"
EGIT_CLONE_TYPE="shallow"

if [[ "${PV}" != 9999 ]]; then
	COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="Boost-1.0"
SLOT="0"
