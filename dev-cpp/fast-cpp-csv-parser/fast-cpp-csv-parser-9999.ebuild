# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


DESCRIPTION="This is a small, easy-to-use and fast header-only library for reading comma separated value (CSV) files."
HOMEPAGE="https://github.com/ben-strasser/fast-cpp-csv-parser"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ben-strasser/${PN}.git"
else
	COMMIT="75600d0b77448e6c410893830df0aec1dbacf8e3"
	SRC_URI="https://github.com/ben-strasser/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="BSD"
SLOT="0"

src_prepare() {
if [[ -n "${COMMIT}" ]]; then
	mv "${WORKDIR}/${PN}-${COMMIT}" "${WORKDIR}/${PN}"
fi
}
src_install() {
	doheader "${PN}/csv.h"
}
