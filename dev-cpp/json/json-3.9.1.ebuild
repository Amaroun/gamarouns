# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="JSON for modern C++"
HOMEPAGE="https://nlohmann.github.io/json/"

inherit cmake-utils

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nlohmann/json.git"
else
	SRC_URI="https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""


#src_install() {
#	dolib.so ${BUILD_DIR}/*.so
#	dobin ${BUILD_DIR}/testcuew
#	doheader -r include/*
#}

