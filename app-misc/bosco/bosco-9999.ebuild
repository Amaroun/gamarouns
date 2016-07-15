# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit git-r3 distutils-r1 eutils versionator

DESCRIPTION="Orienteering software"
HOMEPAGE="http://bosco.durcheinandertal.ch"
EGIT_REPO_URI="http://git.durcheinandertal.ch/bosco.git"

LICENSE="GPLv3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="
	dev-python/storm[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	dev-python/sireader[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
src_prepare() {
	epatch "${FILESDIR}/nonexistent_scripts__test_wwfexport__refference_removal.patch"
}
