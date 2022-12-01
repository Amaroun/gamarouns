# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

DESCRIPTION="UDP Interactive Connectivity Establishment"
HOMEPAGE="https://github.com/paullouisageneau/libjuice"
SRC_URI="https://github.com/paullouisageneau/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="nettle +server tests"

RDEPEND="
	nettle? ( dev-libs/nettle )
	"
DEPEND="${RDEPEND}"

PATCHES+="${FILESDIR}/${PN}-1.0.6_system_deps.patch"

src_configure() {
#option(USE_NETTLE "Use Nettle for hash functions" OFF)
#option(NO_SERVER "Disable server support" OFF)
#option(NO_TESTS "Disable tests build" OFF)

        use nettle && mycmakeargs+=("-DUSE_NETTLE=ON")
        use server || mycmakeargs+=("-DNO_SERVER=ON")
        use tests || mycmakeargs+=("-DNO_TESTS=ON")
        cmake_src_configure
}

src_install() {
	cmake_src_install
}
