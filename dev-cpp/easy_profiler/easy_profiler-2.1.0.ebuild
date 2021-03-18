# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Lightweight cross-platform profiler library for c++"
HOMEPAGE="https://github.com/yse/easy_profiler"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/yse/easy_profiler.git"
else
	SRC_URI="https://github.com/yse/easy_profiler/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT Apache-2.0"
SLOT="0"
IUSE="+gui samples"

DEPEND="
	gui? ( >=dev-qt/qtgui-5.3 )
"

PATCHES+=( "${FILESDIR}/easy_profiler-2.1.0_install_destination.patch" )

src_configure() {
        local mycmakeargs=(
                -DCMAKE_INSTALL_LIBDIR=$(get_libdir)
                -DEASY_PROFILER_NO_GUI=$(usex gui 'NO' 'YES')
                -DEASY_PROFILER_NO_SAMPLES=$(usex samples 'NO' 'YES')
         )
        cmake_src_configure
} 
