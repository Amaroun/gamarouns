# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit unpacker versionator

DESCRIPTION="Scenes pack for luxmark."
HOMEPAGE="http://www.luxmark.info"

DOWNLOAD_VERSION="$(delete_version_separator 2 )"

#SRC_URI="https://bitbucket.org/luxrender/luxmark/downloads/scenes-v3.1beta3.zip"
SRC_URI="https://bitbucket.org/luxrender/luxmark/downloads/${PN/luxmark-/}-v${DOWNLOAD_VERSION}.zip"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"

S=$WORKDIR

src_install() {
	insinto /usr/share/luxmark
	doins -r "${WORKDIR}"/scenes
}
