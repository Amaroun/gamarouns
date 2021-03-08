# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Kernel modules necessary to run the Anbox Android container runtime"
HOMEPAGE="https://anbox.io/"

KEYWORDS="~amd64 ~arm64"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/anbox/anbox-modules.git"
else
	COMMIT="6c10125a7f13908d2cbe56d2d9ab09872755f265" # 29.11.2020
	SRC_URI="
		https://github.com/anbox/anbox/archive/"${COMMIT}".tar.gz -> "${P}".tar.gz
		https://github.com/google/cpu_features/archive/"${EXTCOMMIT}".tar.gz -> cpu_features-"${EXTCOMMIT}".tar.gz
	"
	S=""${WORKDIR}"/"${PN}"-"${COMMIT}""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="sys-kernel/dkms"

RDEPEND="${DEPEND}"

src_install() {

	mv "${S}/ashmem" "anbox-ashmem-1"
	mv "${S}/binder" "anbox-binder-1"
	insinto /usr/src/
	doins -r anbox-ashmem-1
	doins -r anbox-binder-1

	insinto "/etc/modules-load.d/"
	doins "anbox.conf"
	insinto "/lib/udev/rules.d"
	doins "99-anbox.rules"
}

pkg_postinst() {
	dkms install anbox-ashmem/1
	dkms install anbox-binder/1

}
pkg_prerm() {
	dkms uninstall anbox-ashmem/1
	dkms uninstall anbox-binder/1

}
