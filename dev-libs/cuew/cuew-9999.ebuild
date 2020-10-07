# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="This C++ project provides a portable binary archive to be used with boost::serialization."
HOMEPAGE="https://archive.codeplex.com/?p=epa"

#PATCHES="${FILESDIR}/bcd_system_deps.patch"

inherit cmake-utils

if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/CudaWrangler/cuew.git"
else
	SRC_URI="https://github.com/CudaWrangler/cuew/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

PATCHES+=(
	"${FILESDIR}/${PN}_skip_rpath.patch"
        )


src_install() {
	dolib.so ${BUILD_DIR}/*.so
	dobin ${BUILD_DIR}/testcuew
	doheader -r include/*
	insinto usr/share/${PN}/cmake
	newins ${FILESDIR}/Findcuew.cmake cuewConfig.cmake
}
