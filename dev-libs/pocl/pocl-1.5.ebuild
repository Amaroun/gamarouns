EAPI="7"
inherit cmake-utils cmake-multilib llvm

DESCRIPTION="Portable Computing Language"
HOMEPAGE="http://portablecl.org"

PV_RC_SEPARATOR_FIXED=${PV//[_]/-}
PV_FILE_FORMAT=${PV_RC_SEPARATOR_FIXED^^}
SRC_URI="https://github.com/pocl/pocl/archive/v${PV_FILE_FORMAT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV_FILE_FORMAT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=sys-devel/clang-6
	<sys-devel/clang-11
	sys-devel/clang
	sys-apps/hwloc
"

DEPEND="${RDEPEND}"

LLVM_MAX_SLOT="10"

PATCHES=("${FILESDIR}/vendor_opencl_libs_location.epatch"
)
