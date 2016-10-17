# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 cmake-utils
CMAKE_BUILD_TYPE="Release"

DESCRIPTION="The Beignet GPGPU System for Intel Ivybridge GPUs"
HOMEPAGE="http://wiki.freedesktop.org/www/Software/Beignet/"

LICENSE="GPL-2.1+"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://anongit.freedesktop.org/beignet"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://01.org/sites/default/files/${P}-source.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/Beignet-${PV}-Source
fi

DEPEND=">=sys-devel/gcc-4.6
	${PYTHON_DEPS}"
RDEPEND="app-eselect/eselect-opencl
	media-libs/mesa
	sys-devel/clang
	>=sys-devel/llvm-3.5
	x11-libs/libdrm
	x11-libs/libXext
	x11-libs/libXfixes"

pkg_setup() {
	python_setup
}
BEIGNET_DIR=/usr/$(get_libdir)/OpenCL/vendors/intel-beignet

src_prepare() {
	# disable tests for now
	sed -i "s/ADD_SUBDIRECTORY(utests)/#ADD_SUBDIRECTORY(utests)/" CMakeLists.txt || die "sed failed"

	cmake-utils_src_prepare
}
src_configure() {

	local mycmakeargs=( -DCMAKE_INSTALL_PREFIX="${BEIGNET_DIR}/" )

	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install

	insinto /etc/OpenCL/vendors/
	doins intelbeignet.icd

	dodoc -r  docs

	dosym lib64/beignet/libcl.so "${BEIGNET_DIR}"/libOpenCL.so.1
	dosym lib64/beignet/libcl.so "${BEIGNET_DIR}"/libOpenCL.so
	dosym lib64/beignet/libcl.so "${BEIGNET_DIR}"/libcl.so.1
	dosym lib64/beignet/libcl.so "${BEIGNET_DIR}"/libcl.so
}
