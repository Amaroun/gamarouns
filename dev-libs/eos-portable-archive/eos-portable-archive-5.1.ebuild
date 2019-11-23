# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="This C++ project provides a portable binary archive to be used with boost::serialization."
HOMEPAGE="https://archive.codeplex.com/?p=epa"

#PATCHES="${FILESDIR}/bcd_system_deps.patch"

if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/daldegam/eos-portable-archive.git"
else
	SRC_URI="https://github.com/daldegam/eos-portable-archive/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-libs/boost-1.43:0/1.65.0"

src_install() {
	doheader -r eos
}
