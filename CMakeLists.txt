


#[[====================== Top-Level CMakeLists.txt ======================]]


#[[

    The CMake Build system design original is from "tueda/form --branch=appveyor" and 
    redesign/expand functionality by TaiXeflar on "TaiXeflar/form".

    The expanded CMake Build system sources, include CMakeLists.txt, Repo contained CMake modules, 
    CMake insert files are under the GNU GPL v3.0 License which follows the vermaseren/form project license.

 ]]

#[[

                Copyright (C) 1984-2023 J.A.M. Vermaseren
    When using this file you are requested to refer to the publication
    J.A.M. Vermaseren "New features of FORM" math-ph/0010025
    This is considered a matter of courtesy as the development was paid
    for by FOM the Dutch physics granting agency and we would like to
    be able to track its scientific use to convince FOM of its value
    for the community.

    FORM is free software: you can redistribute it and/or modify it under the
    terms of the GNU General Public License as published by the Free Software
    Foundation, either version 3 of the License, or (at your option) any later
    version.

    FORM is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    details.

    You should have received a copy of the GNU General Public License along
    with FORM.  If not, see <http://www.gnu.org/licenses/>.

 ]]


# Upgrade CMake min. version to 3.28.
cmake_minimum_required(VERSION 3.28)

# Set Repo cmake modules append to CMake self existed modules for global call.
#set(CMAKE_MODULE_PATH   "${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_SOURCE_DIR}/cmake/modules")

# Set CMake Policy for CMake Behavior.
include(cmake/CMakePolicy.cmake)


# Defines Form Project's cmake modules directory.

# check for if cmake command contains with Autoconf generated "configure" script alias.
include(cmake/check4_Autoconf.cmake)

# Extract Form version number from form3.h; else if no define then extract from Top-Level CMakeLists.txt.
set(FORM3_H sources/form3.h)
file(READ ${FORM3_H} FORM3_H_CONTENT)
if(NOT DEFINED FORM_MAJOR_VERSION)
    string(REGEX REPLACE "#define  *MAJORVERSION *" "" MAJOR_VERSION "${FORM3_H_CONTENT}")
    if(DEFINED CMAKE_MATCH_1)
        set(FORM_MAJOR_VERSION ${MAJOR_VERSION})
    else()
        set(FORM_MAJOR_VERSION 5)
    endif()
endif()
if(NOT DEFINED FORM_MINOR_VERSION)    
string(REGEX REPLACE "#define  *MINORVERSION *" "" MINOR_VERSION "${FORM3_H_CONTENT}")
    if(DEFINED CMAKE_MATCH_1)
        set(FORM_MINOR_VERSION ${MINOR_VERSION})
    else()
        set(FORM_MINOR_VERSION 0)
    endif()
endif()
if(NOT DEFINED FORM_PATCH_VERSION)
    string(REGEX REPLACE "#define  *PATCHVERSION *" "" PATCH_VERSION "${FORM3_H_CONTENT}")
    if(DEFINED CMAKE_MATCH_1)
        set(FORM_PATCH_VERSION ${PATCH_VERSION})
    else()
        set(FORM_PATCH_VERSION 0)
    endif()
endif()
if(NOT DEFINED FORM_IS_BETA_VERSION)
    set(FORM_IS_BETA_VERSION TRUE)              # <--------- If is Beta, Switch this boolean to TRUE. 
    if(${FORM_IS_BETA_VERSION})
        set(FORM_BETA_TAG "-beta1")             # <--------- If define is Beta version, put beta version tag here.
    endif()
endif()


# Project starts here.
# Add Define of Symbolic Form as C/C++ language.
project(Form 
    VERSION ${FORM_MAJOR_VERSION}.${FORM_MINOR_VERSION}.${FORM_PATCH_VERSION}
    LANGUAGES C CXX)
include(CheckCSourceCompiles)
include(CheckIncludeFileCXX)
include(CheckTypeSize)

include(cmake/check4VersionH.cmake)


# Set CMake Build-Out-Of-Source Rules.
if(${CMAKE_BINARY_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    message(WARNING "Detected building in source dir!")
    message("CMAKE Presents Build out of source.")
    message("You can either mkdir \"build\" or passing \"-B<BUILD_DIR>\" to build.")
    message(FATAL_ERROR "Throwback Build error in source dir!")
endif()
if(EXISTS "${CMAKE_SOURCE_DIR}/CMakeFiles")
    message(FATAL_ERROR "Please remove \"CMakeFiles/\" folder in source dir!")
endif()
if(EXISTS "${CMAKE_SOURCE_DIR}/CMakeCache.txt")
    message(FATAL_ERROR "Please remove \"CMakeCache.txt\" in source dir!")
endif()

# Define the "--prefix" replaced option "INSTALL".
message(CHECK_START "Check for Install Prefix")
if((NOT DEFINED INSTALL) OR (${CMAKE_INSTALL_PREFIX} MATCHES "^(default|Default|guess)$"))
    message(CHECK_FAIL "Not set: Install in default directory ${CMAKE_INSTALL_PREFIX}")
elseif(DEFINED INSTALL)
    set(CMAKE_INSTALL_PREFIX ${INSTALL} CACHE STRING "Customized Install Directory")
    message(CHECK_PASS "${INSTALL}")
endif()

# [Tueda]
# Check for data model.
message(CHECK_START "Check for data model")
check_type_size(char SIZEOF_CHAR)
check_type_size(short SIZEOF_SHORT)
check_type_size(int SIZEOF_INT)
check_type_size(long SIZEOF_LONG)
check_type_size("long long" SIZEOF_LONG_LONG)
check_type_size(void* SIZEOF_VOID_P)

set(sizeof_types "${SIZEOF_CHAR}-${SIZEOF_SHORT}-${SIZEOF_INT}-${SIZEOF_LONG}-${SIZEOF_LONG_LONG}-${SIZEOF_VOID_P}")

if(sizeof_types MATCHES "1-2-4-4-8-4")
    set(ILP32 TRUE)
    set(data_model "ILP32")
elseif(sizeof_types MATCHES "1-2-4-4-8-8")
    set(LLP64 TRUE)
    set(data_model "LLP64")
elseif(sizeof_types MATCHES "1-2-4-8-8-8")
    set(LP64 TRUE)
    set(data_model "LP64")
else()
    message(FATAL_ERROR "Data model ${sizeof_types} not supported")
endif()
message(CHECK_PASS "${sizeof_types} (${data_model})")


# [Tueda]
# Check for "inline" keyword in C.
function(check_c_inline)
  unset(inline PARENT_SCOPE)
  foreach(inline_keyword "inline" "__inline__" "__inline")
    string(TOUPPER "HAVE_C_${inline_keyword}" value)
    check_c_source_compiles("
      typedef int foo_t;
      static ${inline_keyword} foo_t static_foo() { return 0; }
      ${inline_keyword} foo_t foo() { return 0; }
      int main() { return 0; }
    " ${value})
    if(${value})
      if("${inline_keyword}" STREQUAL "inline")
      else()
        set(inline "${inline_keyword}" PARENT_SCOPE)
      endif()
      return()
    endif()
  endforeach()
  set(inline " " PARENT_SCOPE)
endfunction()

check_c_inline()

# [Tueda]
# Check for header files.
check_include_file_cxx(boost/unordered_map.hpp HAVE_BOOST_UNORDERED_MAP_HPP)
check_include_file_cxx(boost/unordered_set.hpp HAVE_BOOST_UNORDERED_SET_HPP)
check_include_file_cxx(tr1/unordered_map HAVE_TR1_UNORDERED_MAP)
check_include_file_cxx(tr1/unordered_set HAVE_TR1_UNORDERED_SET)
check_include_file_cxx(unordered_map HAVE_UNORDERED_MAP)
check_include_file_cxx(unordered_set HAVE_UNORDERED_SET)

# % Taixeflar
# Add form build control flags. ----> Form/TForm/PForm
message(CHECK_START "Checking for Sequential Form build")
if(NOT DEFINED BUILD_FORM)
    set(BUILD_FORM TRUE CACHE BOOL "Enable build Form")
    message(CHECK_PASS "ON")
elseif(NOT ${BUILD_FORM})
    message(CHECK_PASS "OFF")
elseif(${BUILD_FORM})
    message(CHECK_PASS "ON")
endif()

message(CHECK_START "Checking for Thread version Form build")
if(NOT DEFINED BUILD_TFORM)
    set(BUILD_TFORM OFF CACHE BOOL "Enable build Thread Form")
    message(CHECK_PASS "Not set")
elseif(${BUILD_TFORM})
    message(CHECK_PASS "ON")
elseif(NOT ${BUILD_TFORM})
    message(CHECK_PASS "OFF")
endif()

message(CHECK_START "Checking for MPI version Form build")
if(NOT DEFINED BUILD_PFORM)
    set(BUILD_PFORM OFF CACHE BOOL "Enable build Parallel Form")
    message(CHECK_PASS "Not set")
elseif(${BUILD_PFORM})
    message(CHECK_PASS "ON")
    include(FindMPI)
elseif(NOT ${BUILD_PFORM})
    message(CHECK_PASS "OFF")
endif()

# Check for linking Libraries.
message(STATUS "Check for 3rd-party link options.")

# Enabling with POSIX Threads library on TForm.
message(CHECK_START "Check for pthreads for tform.")
if(NOT ${BUILD_TFORM})
    message(CHECK_PASS "Skip")
elseif(${BUILD_TFORM})
    if(${UNIX})
        find_package(Threads REQUIRED)
        if(${THREADS_FOUND})
            message(CHECK_PASS "Found")
        else()
            message(CHECK_FAIL "Failed")
        endif()
    elseif(${WINDOWS})
        include(cmake/modules/FindPThread4w.cmake)
    endif()
endif()


# Enable linking with zlib.
message(CHECK_START "Linking ZLIB")
if(NOT DEFINED WITH_ZLIB)
    set(WITH_ZLIB OFF CACHE BOOL "Form Linking with zlib")
    message(CHECK_PASS "Not set")
elseif(${WITH_ZLIB})
    message(CHECK_PASS "ON")
    find_package(ZLIB REQUIRED)
    include_directories(${ZLIB_INCLUDE_DIR})
elseif(NOT ${WITH_ZLIB})
    message(CHECK_PASS "OFF")
endif()
# Enable linking with zstd.
message(CHECK_START "Linking ZSTD")
if(NOT DEFINED WITH_ZSTD)
    set(WITH_ZSTD OFF CACHE BOOL "Form Linking with zstd")
    message(CHECK_PASS "Not set")
elseif(${WITH_ZSTD})
    message(CHECK_PASS "ON")
    find_package(Zstd REQUIRED)
    include_directories(${ZSTD_INCLUDE_DIR})
elseif(NOT ${WITH_ZSTD})
    message(CHECK_PASS "OFF")
endif()
# Enable linking with GNU Multiple Precision Arithmetic Library(GMP).
message(CHECK_START "Linking GMP")
if(NOT DEFINED WITH_GMP)
    set(WITH_GMP OFF CACHE BOOL "Form Linking with GMP library")
    message(CHECK_PASS "Not Set")
elseif(${WITH_GMP})
    message(CHECK_PASS "ON")
    if(${MSVC})
        message(AUTHOR_WARNING 
        "Warning: You are using MSVC to link with GMP libraries. 
        Please make sure the MSVC can identify GMP libraries with name `libgmp.lib`.")
    endif()
    include(cmake/modules/FindGMP.cmake)
    include_directories(${GMP_INCLUDE_DIR})
elseif(NOT ${WITH_GMP})
    message(CHECK_PASS "OFF")
endif()
# Enable Linking with MPFR.
message(CHECK_START "Linking MPFR")
if(NOT DEFINED WITH_MPFR)
    set(WITH_MPFR OFF CACHE BOOL "Form Linking with MPFR Library")
    message(CHECK_PASS "Not set")
elseif(${WITH_MPFR})
    message(CHECK_PASS "ON")
    if(${MSVC})
        message(AUTHOR_WARNING 
        "Warning: You are using MSVC to link with MPFR libraries. 
        Please make sure the MSVC can identify MPFR libraries with name `libmpfr.lib`.")
    endif()
    include(cmake/modules/FindMPFR.cmake)
    include_directories(${MPFR_INCLUDE_DIR})
elseif(NOT ${WITH_MPFR})
    message(CHECK_PASS "OFF")
endif()

message(CHECK_START "Linking shared/static libraries")
if(NOT DEFINED SHARE_LIB)
    set(SHARE_LIB OFF CACHE BOOL "Form Build linking with Shared/Static Libraries")
    message(CHECK_FAIL "Not set")
elseif(NOT ${SHARE_LIB})
    option(BUILD_SHARED_LIBS OFF)
    message(CHECK_PASS "STATIC")
elseif(${SHARE_LIB})
    option(BUILD_SHARED_LIBS ON)
    message(CHECK_FAIL "SHARED")
endif()

#[ Enable/Disable float support for FORM.
# Set a AUTHOR_WARNING for only developers to mension the error occurs on compiling with enable float.
# Remove this after problems solved.
message(CHECK_START "Enable float options")
if(NOT DEFINED WITH_FLOAT)
    set(WITH_FLOAT OFF CACHE BOOL "Enable build with float support")
    message(CHECK_PASS "Not set")
elseif(${WITH_FLOAT})
    message(WARNING "Form build with float features forced turn ON.")
    message(STATUS "Starting find GMP and MPFR libraries.")
    include(cmake/modules/FindGMP.cmake)
    include(cmake/modules/FindMPFR.cmake)
    include_directories(${GMP_INCLUDR_DIR} ${MPFR_INCLUDE_DIR})
    message(AUTHOR_WARNING "
Warning: WITH_FLOAT options will engage compile error issues.
If you are not developing on this issue, please set \"WITH_FLOAT\" to 'off', but \"WITH_GMP\" and \"WITH_MPFR\" will not be set off automatically. 
If you want GMP and MPFR disabled with \"WITH_FLOAT\" switch off later, please pass \"-DWITH_GMP=OFF -DWITH_MPFR=OFF\", or regenerate buildfiles again by delete cmake generated files/folders'.
    ")
    message(CHECK_PASS "ON")
    set(WITH_GMP ON)
    set(WITH_MPFR ON)
elseif(NOT ${WITH_FLOAT})
    message(CHECK_PASS "OFF")
endif()
#]]

# Add build EnvModules for Form.
message(CHECK_START "Enable Environment Modules file")
if(NOT DEFINED WITH_MODULES)
    set(WITH_MODULES OFF CACHE BOOL "Enable build Modulefiles")
    message(CHECK_PASS "Not set")
elseif(NOT ${WITH_MODULES})
    message(CHECK_PASS "Disabled")
elseif(${WITH_MODULES})
    message(CHECK_PASS "Enabled")
endif()

# Add build log printing flags.
if(NOT DEFINED BUILDLOG)
    set(BUILDLOG ON CACHE BOOL "Print build information in default")
    message(STATUS "Enabled export build details during build.")
elseif(NOT BUILDLOG)
    message(STATUS "Disabled export build log.")
endif()



# Process subdirectories.
add_subdirectory(sources)
