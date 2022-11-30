# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

DESCRIPTION="C/C++ WebRTC network library"
HOMEPAGE="https://github.com/SergiusTheBest/plog"
SRC_URI="https://github.com/paullouisageneau/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="gnutls +openssl +media +websocket examples +nice juice json tests examples stdcall"
REQUIRED_USE=" ^^ ( juice nice ) ^^ ( openssl gnutls ) "

RDEPEND="
	dev-cpp/plog
	dev-libs/glib
	net-libs/libsrtp
	net-libs/usrsctp
	nice? ( net-libs/libnice )
	gnutls? ( net-libs/gnutls )
	openssl? ( dev-libs/openssl )
	tests? ( dev-cpp/json )
	"
DEPEND="${RDEPEND}"

PATCHES+="${FILESDIR}/libdatachannel-0.17.12_system_deps.patch"

src_configure() {
#option(USE_GNUTLS "Use GnuTLS instead of OpenSSL" OFF)
#option(USE_NICE "Use libnice instead of libjuice" OFF)
#option(USE_SYSTEM_SRTP "Use system libSRTP" OFF)
#option(USE_SYSTEM_JUICE "Use system libjuice" OFF)
#option(NO_WEBSOCKET "Disable WebSocket support" OFF)
#option(NO_MEDIA "Disable media transport support" OFF)
#option(NO_EXAMPLES "Disable examples" OFF)
#option(NO_TESTS "Disable tests build" OFF)
#option(CAPI_STDCALL "Set calling convention of C API callbacks stdcall" OFF)

        mycmakeargs+=("-DUSE_SYSTEM_SRTP=ON")
        mycmakeargs+=("-DUSE_SYSTEM_JUICE=ON")
        use gnutls && mycmakeargs+=("-DUSE_GNUTLS=ON")
        use openssl && mycmakeargs+=("-DUSE_GNUTLS=OFF")
        use nice   && mycmakeargs+=("-DUSE_NICE=ON")
        use juice  && mycmakeargs+=("-DUSE_NICS=OFF")
        use websocket || mycmakeargs+=("-DNO_WEBSOCKET=ON")
        use media || mycmakeargs+=("-DNO_MEDIA=ON")
        use examples || mycmakeargs+=("-DNO_EXAMPLES=ON")
        use tests || mycmakeargs+=("-DNO_TESTS=ON")
        use stdcall && mycmakeargs+=("-DCAPI_STDCSLL=ON")
        cmake_src_configure
}

src_install() {
	cmake_src_install
}
