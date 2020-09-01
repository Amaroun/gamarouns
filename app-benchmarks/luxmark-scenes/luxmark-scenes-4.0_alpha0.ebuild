# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit unpacker

DESCRIPTION="Scenes pack for luxmark."
HOMEPAGE="http://www.luxmark.info"

DOWNLOAD_VERSION="${PV//_/}"

SRC_URI="https://github.com/LuxCoreRender/LuxMark/releases/download/luxmark_v${DOWNLOAD_VERSION}/scenes.tgz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"

S=$WORKDIR

src_install() {
	insinto /usr/share/luxmark
	doins -r "${WORKDIR}"/scenes
}
