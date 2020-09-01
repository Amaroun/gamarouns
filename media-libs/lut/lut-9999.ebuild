# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="C++ 11 single required source file, that can be used to achieve color correction and color grading"
HOMEPAGE="https://github.com/ray-cast/lut"

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ray-cast/lut.git"
else
	SRC_URI="https://github.com/ray-cast/lut/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

src_install() {
	doheader lut.hpp
}

