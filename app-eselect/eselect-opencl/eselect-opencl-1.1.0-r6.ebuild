# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib

DESCRIPTION="Utility to change the OpenCL implementation being used"
HOMEPAGE="https://www.gentoo.org/"

# Source:
# http://www.khronos.org/registry/cl/api/${CL_ABI}/opencl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_platform.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl_gl_ext.h
# http://www.khronos.org/registry/cl/api/${CL_ABI}/cl.hpp

# Using copy by Mario Kicherer #496418

CL_ABIS=(1.0 1.1 1.2 2.0 2.1)

SRC_URI="
	http://packages.gentooexperimental.org/opencl-cpp-headers.tar
	"

for CL_ABI in "${CL_ABIS[@]}" ; do
	SRC_URI="${SRC_URI} https://github.com/KhronosGroup/OpenCL-Headers/archive/opencl${CL_ABI/./}.zip"
done


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND=">=app-admin/eselect-1.2.4"

S="${WORKDIR}"

pkg_postinst() {
	local impl="$(eselect opencl show)"
	if [[ -n "${impl}"  && "${impl}" != '(none)' ]] ; then
		eselect opencl set "${impl}"
	fi
}

src_install() {
	insinto /usr/share/eselect/modules
	doins ${FILESDIR}/opencl.eselect

	# We install all versions of OpenCL headers
	for CL_ABI in "${CL_ABIS[@]}" ; do
		mkdir -p "${D}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}"
		cp "${WORKDIR}"/OpenCL-Headers-opencl${CL_ABI/./}/* "${D}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}"
#		for f in ${headers[@]}; do
#			if [ -r "${WORKDIR}/OpenCL-Headers-opencl${CL_ABI/./}/${f}" ] ; then
#				cp "${WORKDIR}"/OpenCL-Headers-opencl${CL_ABI/./}/${f} "${D}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/${f}"
#			fi
#		done

		if [ -r "${WORKDIR}/${CL_ABI}/cl.hpp" ] ; then
			cp "${WORKDIR}/${CL_ABI}/cl.hpp" "${D}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/"
			einfo "${WORKDIR}/${CL_ABI}/cl.hpp copied to ${D}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABI}/"
		else
			einfo "${WORKDIR}/${CL_ABI}/cl.hpp does not exist"
		fi
	done

	# Create symlinks to newest. Maybe this should be switchable?
	dosym "${D}/usr/$(get_libdir)/OpenCL/global/include/CL-${CL_ABIS[-1]}/" "/usr/$(get_libdir)/OpenCL/global/include/CL"
}
