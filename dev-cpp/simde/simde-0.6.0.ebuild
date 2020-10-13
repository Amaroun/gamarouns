# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="Implementations of SIMD instruction sets for systems which natively don't support them"
HOMEPAGE="https://simd-everywhere.github.io/blog/"

inherit meson

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/simd-everywhere/${PN}.git"
else
	SRC_URI="https://github.com/simd-everywhere/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

src_configure() {
	local emesonargs=( $(meson_use test tests) )

	meson_src_configure
}

