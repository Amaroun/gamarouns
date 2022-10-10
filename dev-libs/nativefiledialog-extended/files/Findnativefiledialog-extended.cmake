
FIND_PACKAGE( PackageHandleStandardArgs )

FIND_PATH( nativefiledialog-extended_LOCATION include/nfd.h
  "$ENV{NativeFileDialogExtended_ROOT}"
  )

FIND_PACKAGE_HANDLE_STANDARD_ARGS( nativefiledialog-extended
  REQUIRED_VARS CLEW_LOCATION
  )

IF( nativefiledialog-extended_FOUND )
  SET( nativefiledialog-extended_INCLUDE_DIR ${CLEW_LOCATION}/include
    CACHE PATH "nativefiledialog-extended include directory")

  SET( nativefiledialog-extended_LIBRARY_DIR ${nativefiledialog-extended_LOCATION}/lib
    CACHE PATH "nativefiledialog-extended library directory" )

  FIND_LIBRARY( nativefiledialog-extended_LIBRARY nfd
    PATHS ${NativeFileDialogExtended_LIBRARY_DIR}
    NO_DEFAULT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    )

  SET( nativefiledialog-extended_LIBRARIES "")
  LIST( APPEND nativefiledialog-extended_LIBRARIES ${nativefiledialog-extended_LIBRARY} )

ENDIF( nativefiledialog-extended_FOUND )
