# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils
#cmake-utils

DESCRIPTION="PortableCL: opensource implementation of the OpenCL standard"
HOMEPAGE="http://portablecl.org/"
EGIT_REPO_URI="https://github.com/pocl/pocl.git"

SLOT="0"
LICENSE="MIT"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/ocl-icd
	>=sys-devel/llvm-4.0
	>=sys-devel/clang-4.0
	>=sys-apps/hwloc-1.0
	>=app-eselect/eselect-opencl-1.1.0-r4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

POCL_DIR="/usr/$(get_libdir)/OpenCL/vendors/pocl"

pkg_pretend() {
	# Needs an OpenCL 1.2 ICD, mesa and nvidia are invalid
	# Maybe ati works, feel free to add/fix if you can test
	if [[ $(eselect opencl show) == 'ocl-icd' ]]; then
		einfo "Valid OpenCL ICD set"
	else
		eerror "Please use a supported ICD:"
		eerror "eselect opencl set ocl-icd"
		die "OpenCL ICD not set to a supported value"
	fi
}

