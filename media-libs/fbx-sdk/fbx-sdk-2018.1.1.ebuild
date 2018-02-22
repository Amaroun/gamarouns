# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit versionator multilib unpacker

DESCRIPTION="Platform and API toolkit to transfer existing content into the FBX format."
HOMEPAGE="https://www.autodesk.com/products/fbx/overview"

VER_YEAR="$(get_version_component_range 1)"
VER_MAJOR="$(get_version_component_range 2)"
VER_MINOR="$(get_version_component_range 3)"

PACKAGE_FILE_NAME="fbx${VER_YEAR}${VER_MAJOR}_${VER_MINOR}_fbxsdk_linux"

SRC_URI="http://download.autodesk.com/us/fbx/${VER_YEAR}/${PV}/${PACKAGE_FILE_NAME}.tar.gz"

LICENSE="Autodesk-LSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc samples"


src_unpack() {
	default
	chmod +x "${WORKDIR}/${PACKAGE_FILE_NAME}"|| die "Failed to make package executable"
	mkdir "$S"
	printf "yes\nn\n" | "${WORKDIR}/${PACKAGE_FILE_NAME}" "${S}" > "${WORKDIR}/${PACKAGE_FILE_NAME}.log" 

}

src_install() {

	if  use amd64 ; then
		fbxarch="x64"
	elif use x86 ; then
		fbxarch="x86"
	else
		die "Unsupported arch"
	fi

	if  use debug ; then
		fbxbuild="debug"
	else
		fbxbuild="release"
	fi

	dolib "lib/gcc4/$fbxarch/$fbxbuild/libfbxsdk.so"

	insinto "usr"
	doins -r "include"

	if use samples ; then
		dodoc -r "samples"
	fi
	if use doc ; then
		dodoc "FBX_SDK_Online_Documentation.html"
	fi
	dodoc "License.txt"


}
