# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A cross-platform C library to retrieve CPU features (such as available instructions) at runtime."
HOMEPAGE="https://github.com/google/cpu_features"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/cpu_features"
else
	SRC_URI="https://github.com/google/cpu_features/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="Apache-2.0"
SLOT="0"

#RDEPEND="dev-cpp/gtest"
#DEPEND="${RDEPEND}"
