# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="http://llvm.org/git/${PN}.git"

GIT_ECLASS="git-r3"
EXPERIMENTAL="true"

inherit base python-any-r1 $GIT_ECLASS

DESCRIPTION="OpenCL C library"
HOMEPAGE="http://libclc.llvm.org/"

LICENSE="|| ( MIT BSD )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=sys-devel/clang-3.6
	>=sys-devel/llvm-3.6"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	./configure.py \
		--with-llvm-config="${EPREFIX}/usr/bin/llvm-config" \
		--prefix="${EPREFIX}/usr" || die
}

