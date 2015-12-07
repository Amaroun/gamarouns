# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils mercurial flag-o-matic

DESCRIPTION="Library to accelerate the ray intersection process by using GPUs"
HOMEPAGE="http://www.luxrender.net"
EHG_REPO_URI="https://bitbucket.org/luxrender/luxrays"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opencl"

DEPEND=">=dev-libs/boost-1.43
	media-libs/freeimage
	virtual/opengl
	opencl? ( virtual/opencl )"

#CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	append-flags -fPIC
        use opencl || append-flags -DLUXRAYS_DISABLE_OPENCL
	use debug && append-flags -ggdb

	use opencl || mycmakeargs=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make luxcore
}

src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include
	doins -r include/luxcore

	dolib.a ${BUILD_DIR}/lib/libluxcore.a
}

