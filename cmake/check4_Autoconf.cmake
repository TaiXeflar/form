
# Define if insert with Autoconf "configure" shell script contained alias.

if(CC)
    set(CMAKE_C_COMPILER ${CC} CACHE STRING "Selected C Compiler")
endif()
if(CXX)
    set(CMAKE_CXX_COMPILER ${CXX} CACHE STRING " Selected CXX Compiler")
endif()
if(CFLAGS)
    set(CMAKE_C_FLAGS ${CFLAGS_FIXED} CACHE STRING "Added C Compiler Flags")
endif()
if(CXXFLAGS)
    set(CMAKE_CXX_FLAGS ${CXXFLAGS_FIXED} CACHE STRING "Added CXX Compiler Flags")
endif()
if(LDFLAGS)
    set(CMAKE_EXE_LINKER_FLAGS ${LDFLAGS} CACHE STRING "Added CXX Compiler Flags")
endif()

#
#   Here, We(me) set a deprecation warning for new cmake control to focus on stable single build first; 
#       that's we(me) consider to give up the "--enable-debug" option. We(me) want cmake can focus on 
#       build a single build release first; we(me) encourage users build a single configuration by using 
#       CMake cache entry "-D CMAKE_BUILD_TYPE=<CONFIG>".
# 
# Of course we can keep this warning, if we(me) have the chance to achieve multi configuration. 

if(NOT DEFINED ENABLE_DEBUG)
    unset(ENABLE_DEBUG)
elseif(DEFINED ENABLE_DEBUG)
    if((NOT DEFINED CMAKE_BUILD_TYPE) AND (NOT DEFINED TYPE))
        message(DEPRECATION 
        "We are enabling test for users passing \"CMAKE_BUILD_TYPE\" to build a Debug version FORM Build.\nThis flag will be deprecate in a future release.")
        message(AUTHOR_WARNING
        "This function will be set to a deprecation or keep it for a form multi-version-build such as VS20XX Solution/Ninja-multiconfig.")
        message(STATUS "Building Debug FORM build.")
        set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "FORM project build type")
        unset(ENABLE_DEBUG)
    else()
        message(FATAL_ERROR 
        "You have passed different Build types.
        CMake can't generate a correct build files. Please delete them and re-run CMake command.")
    endif()
endif()

#   We(me) using CMake defined 4 build types: Debug, Release, RelWithDebInfo, MinSizeRel.
set(AVAIL_BUILD_TYPE "Debug;Release;RelWithDebInfo;MinSizeRel")
if(DEFINED TYPE)
    if(NOT ${TYPE} IN_LIST AVAIL_BUILD_TYPE)
        message(FATAL_ERROR "Unknown CMake build Type: ${TYPE}")
    endif()
    set(CMAKE_BUILD_TYPE ${TYPE} CACHE STRING "Selected Build Type")
endif()
if(DEFINED CMAKE_BUILD_TYPE)
    if(NOT ${CMAKE_BUILD_TYPE} IN_LIST AVAIL_BUILD_TYPE)
        message(FATAL_ERROR "Unknown CMake build Type: ${CMAKE_BUILD_TYPE}")
    endif()
elseif(NOT DEFINED CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "CMake build Type")
endif()

