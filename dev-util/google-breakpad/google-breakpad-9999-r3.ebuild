# Copyright 2010 Techwolf Lupindo
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit base git-r3 autotools flag-o-matic

DESCRIPTION="An open-source multi-platform crash reporting system"
HOMEPAGE="http://code.google.com/p/google-breakpad/"
EGIT_REPO_URI="https://chromium.googlesource.com/breakpad/breakpad"

EGIT_CHECKOUT_DIR=${WORKDIR}/${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_unpack() {
	git-r3_src_unpack

	git-r3_fetch https://chromium.googlesource.com/linux-syscall-support
	git-r3_checkout https://chromium.googlesource.com/linux-syscall-support ${EGIT_CHECKOUT_DIR}/src/third_party/lss
}
src_prepare() {
	eautoreconf
	eautomake
}
src_configure() {
	append-flags -fPIC 
	econf
}

src_install() {
	base_src_install
	# Install headers that some programs require to build.
	cd "${S}"
	insinto /usr/include/breakpad
	doins src/client/linux/handler/exception_handler.h
	insinto /usr/include/breakpad/common
	doins src/google_breakpad/common/*.h
	insinto /usr/include/breakpad/client/linux/minidump_writer
	doins src/client/linux/minidump_writer/*.h
	insinto /usr/include/breakpad/client/linux/crash_generation
	doins src/client/linux/crash_generation/*.h
	insinto /usr/include/breakpad/client/linux/dump_writer_common
	doins src/client/linux/dump_writer_common/*.h
}
