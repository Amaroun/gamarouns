
FIND_PACKAGE( PackageHandleStandardArgs )

FIND_PATH( CUEW_LOCATION include/cuew.h
  "$ENV{CUEW_ROOT}"
  )

FIND_PACKAGE_HANDLE_STANDARD_ARGS( cuew
  REQUIRED_VARS CUEW_LOCATION
  )

IF( cuew_FOUND )
  SET( cuew_INCLUDE_DIR ${CUEW_LOCATION}/include
    CACHE PATH "cuew include directory")

  SET( cuew_LIBRARY_DIR ${CUEW_LOCATION}/lib
    CACHE PATH "cuew library directory" )

  FIND_LIBRARY( cuew_LIBRARY cuew
    PATHS ${cuew_LIBRARY_DIR}
    NO_DEFAULT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    )

  SET( cuew_LIBRARIES "")
  LIST( APPEND cuew_LIBRARIES ${cuew_LIBRARY} )

ENDIF( cuew_FOUND )
