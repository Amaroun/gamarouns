# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"


DESCRIPTION="Scripts and pre-compiled binaries to update Raspberry Pi4 bootloader EEPROM"
HOMEPAGE="https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md"



if [[ "$PV" == "9999" ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/raspberrypi/rpi-eeprom.git"
else
	SRC_URI="https://codeload.github.com/raspberrypi/rpi-eeprom/tar.gz/v${PV} -> ${P}.tar.gz"
fi


LICENSE="BSD raspberrypi-eeprom-firmware"

SLOT="0"
KEYWORDS="~arm64"



src_install() {
	dodoc LICENSE
	insinto /lib/firmware/raspberrypi/bootloader
	doins -r firmware/*
	dosbin rpi-eeprom-config
	dosbin rpi-eeprom-update
	dosbin rpi-eeprom-update-default
	dosbin vl805
}

