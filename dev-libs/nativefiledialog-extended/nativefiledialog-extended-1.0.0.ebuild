# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="File dialog library with C and C++ bindings, based on nativefiledialog"
HOMEPAGE="https://github.com/btzy/nativefiledialog-extended"

inherit cmake

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	KEYWORDS=""

	EGIT_REPO_URI="https://github.com/btzy/nativefiledialog-extended.git"
else
 	KEYWORDS="~amd64 ~arm64"
	SRC_URI="https://github.com/btzy/nativefiledialog-extended/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
IUSE="test"

RESTRICT="!test? ( test )"
PATCHES=( "${FILESDIR}/PN-1.0.0-no-static.patch" )

src_prepare() {
	sed -e "s|DESTINATION lib|DESTINATION $(get_libdir)|g" -i src/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DNFD_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
src_install() {
        cmake_src_install
        insinto usr/share/${PN}/cmake
        newins ${FILESDIR}/Find${PN}.cmake ${PN}-config.cmake
}
