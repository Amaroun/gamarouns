# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit cmake-utils

DESCRIPTION="A blocking, shuffling and loss-less compression library that can be faster than `memcpy()`. "
HOMEPAGE="http://blosc.org"



if [[ "$PV" == "9999" ]] ; then
	inherit gir-r3

	EGIT_REPO_URI="https://github.com/Blosc/c-blosc.git"
else
	SRC_URI="https://codeload.github.com/Blosc/c-blosc/tar.gz/v${PV} -> ${P}.tar.gz"
fi


LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 cpu_flags_x86_avx2 static-libs +shared-libs +snappy +zlib +zstd +lz4 benchmarks test"

REQUIRED_USE="snappy? ( snappy )
		zlib? ( zlib )
		zstd? ( zstd )
		lz4?  ( lz4 )"

RDEPEND="zlib? ( sys-libs/zlib )
	snappy? ( app-arch/snappy )
	zstd? ( app-arch/zstd )
	lz4? ( app-arch/lz4 ) "

DEPEND="${RDEPEND}"

src_configure() {

local mycmakeargs=(
		-DBUILD_STATIC=$(usex static-libs)
		-DBUILD_SHARED=$(usex shared-libs)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_BENCHMARKS=OFF
		-DDEACTIVATE_SSE2=$(usex !cpu_flags_x86_sse2)
		-DDEACTIVATE_AVX2=$(usex !cpu_flags_x86_avx2)
		-DDEACTIVATE_LZ4=$(usex !lz4)
		-DDEACTIVATE_SNAPPY=$(usex !snappy)
		-DDEACTIVATE_ZLIB=$(usex !zlib)
		-DDEACTIVATE_ZSTD=$(usex !zstd)
		-DPREFER_EXTERNAL_LZ4=ON
		-DPREFER_EXTERNAL_SNAPPY=ON
		-DPREFER_EXTERNAL_ZLIB=ON
		-DPREFER_EXTERNAL_ZSTD=ON
	)
	cmake-utils_src_configure
}


