# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="OpenCL 1.2 implementation for CPUs"
HOMEPAGE="https://code.google.com/p/freeocl/"
EGIT_REPO_URI="https://github.com/zuzuf/freeocl.git"

LICENSE="GPL3 LGPL3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	cmake-utils_src_install

	einfo "Moving files into vendor-specific position..."

	pushd "${D}"

	rm etc/OpenCL/vendors/freeocl.icd

	echo "/usr/$(get_libdir)/OpenCL/vendors/${PN}/libFreeOCL.so" > "etc/OpenCL/vendors/${PN}.icd"

	VENDOR_DIR=usr/"$(get_libdir)/OpenCL/vendors/${PN}/"
	mkdir -p "${VENDOR_DIR}" || die "mkdir failed"

	mv usr/"$(get_libdir)"/lib* "${VENDOR_DIR}/" || die "mv failed"
	
	mv usr/include/FreeOCL "${VENDOR_DIR}/include" || die "mv failed"
	popd
}
