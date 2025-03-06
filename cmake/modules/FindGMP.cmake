

# Try to find the GNU Multiple Precision Arithmetic Library (GMP).

if(GMP_INCLUDES AND GMP_LIBRARIES)
    set(GMP_FIND_QUIETLY FALSE)
endif (GMP_INCLUDES AND GMP_LIBRARIES)

if(${CYGWIN})
    find_path(GMP_INCLUDES
        NAMES gmp.h
        PATHS $ENV{GMPDIR} ${INCLUDE_INSTALL_DIR})
    find_library(GMP_LIBRARIES 
        NAMES libgmp.dll.a
        PATHS $ENV{GMPDIR} ${LIB_INSTALL_DIR})
else()
    find_path(GMP_INCLUDES
        NAMES gmp.h
        PATHS $ENV{GMPDIR} ${INCLUDE_INSTALL_DIR})
    find_library(GMP_LIBRARIES 
        NAMES libgmp
        PATHS $ENV{GMPDIR} ${LIB_INSTALL_DIR})
endif()


  
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMP DEFAULT_MSG
                                  GMP_INCLUDES GMP_LIBRARIES)
mark_as_advanced(GMP_INCLUDES GMP_LIBRARIES)