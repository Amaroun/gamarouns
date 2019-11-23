# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake-utils

DESCRIPTION="Lightweight profiler library for c++"
HOMEPAGE="https://github.com/yse/easy_profiler"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/yse/easy_profiler.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86 ~arm  ~arm64"
	SRC_URI="https://github.com/yse/easy_profiler/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
KEYWORDS="~arm ~arm64 ~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	"
#	dev-qt/qtwebkit:5
DEPEND="${RDEPEND}"

RESTRICT=test

#src_install() {
#	dobin "${BUILD_DIR}/bin/profiler_gui"
#	dobin "${BUILD_DIR}/bin/profiler_reader"
#	dolib.so "${BUILD_DIR}/bin/libeasy_profiler.so"
#}
