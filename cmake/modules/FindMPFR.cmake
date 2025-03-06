

# Try to find the GNU Multiple Precision Floating-Point Reliable Library (MPFR).

if(MPFR_INCLUDES AND MPFR_LIBRARIES)
    set(MPFR_FIND_QUIETLY FALSE)
endif(MPFR_INCLUDES AND MPFR_LIBRARIES)


if(${CYGWIN})
    find_path(MPFR_INCLUDES
        NAMES mpfr.h
        PATHS $ENV{MPFRDIR} ${INCLUDE_INSTALL_DIR}) 
    find_library(MPFR_LIBRARIES 
        NAMES libmpfr.dll.a
        PATHS $ENV{MPFRDIR} ${LIB_INSTALL_DIR})
else()
    find_path(MPFR_INCLUDES
        NAMES mpfr.h
        PATHS $ENV{MPFRDIR} ${INCLUDE_INSTALL_DIR}) 
    find_library(MPFR_LIBRARIES 
        NAMES libmpfr 
        PATHS $ENV{MPFRDIR} ${LIB_INSTALL_DIR})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MPFR DEFAULT_MSG
                                  MPFR_INCLUDES MPFR_LIBRARIES)
mark_as_advanced(MPFR_INCLUDES MPFR_LIBRARIES)