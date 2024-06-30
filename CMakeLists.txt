

cmake_minimum_required(VERSION 3.15)        # % TaiXeflar: Upgrade CMake min. version to 3.15.
project(form LANGUAGES C CXX)               # % TaiXeflar: Add Define of Symbolic Form as C/C++ language.

include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CheckIncludeFileCXX)
include(CheckTypeSize)


# % TaiXeflar: Set CMake Build-Out-Of-Source Rules.

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

# % TaiXeflar: Define Form version by Top-level CMakeLists.txt.
set(FORM_MAJOR_VERSION 5)
set(FORM_MINOR_VERSION 0)
set(FORM_PATCH_VERSION 0)


# Check for data model.

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

# Check for header files.

check_include_file_cxx(boost/unordered_map.hpp HAVE_BOOST_UNORDERED_MAP_HPP)
check_include_file_cxx(boost/unordered_set.hpp HAVE_BOOST_UNORDERED_SET_HPP)
check_include_file_cxx(tr1/unordered_map HAVE_TR1_UNORDERED_MAP)
check_include_file_cxx(tr1/unordered_set HAVE_TR1_UNORDERED_SET)
check_include_file_cxx(unordered_map HAVE_UNORDERED_MAP)
check_include_file_cxx(unordered_set HAVE_UNORDERED_SET)

# Checking OS system name by CMAKE function.
set(OS ${CMAKE_SYSTEM_NAME})
if(OS STREQUAL "Windows")
    set(WINDOWS TRUE)
elseif(OS STREQUAL "UNIX" OR "LINUX" OR "CYGWIN" OR "MSYS")
    set(UNIX TRUE)
else()
    message(FATAL_ERROR "${CMAKE_SYSTEM_NAME} not supported to build. Stop.")
endif()
message("Building Form ${FORM_MAJOR_VERSION}.${FORM_MINOR_VERSION}.${FORM_PATCH_VERSION} .")
message("Building Form on: ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_HOST_SYSTEM_PROCESSOR}")
message("Building Form to: ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}")
 

# % Taixeflar
# Adding CPack for packing built form compiler executable as release package.
#[
if(NOT DEFINED EXPORT_XZTARBALL)
    if(NOT DEFINED CPACK_PACKAGE_INSTALL_DIRECTORY)
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "FORM")
    endif()
    if(NOT DEFINED CPACK_PACKAGE_VENDOR)
    set(CPACK_PACKAGE_VENDOR "Vermaseren")
    endif()
    set(CPACK_PACKAGE_VERSION "${FORM_MAJOR_VERSION}.${FORM_MAJOR_VERSION}.${FORM_PATCH_VERSION}")
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")
    set(CPACK_VERBATIM_VARIABLES YES)
    if(NOT CPACK_GENERATOR)
        set(CPACK_GENERATOR TXZ)
        message(STATUS "CPack: generator set to ${CPACK_GENERATOR}")
      endif()
    include(CPack)
endif()
#]]


# Add control flags.
if(NOT DEFINED BUILD_FORM)
    set(BUILD_FORM TRUE CACHE STRING "")
endif()
if(NOT DEFINED BUILD_TFORM)
    set(BUILD_TFORM OFF CACHE STRING "Enable build Thread Form")
    message(NOTICE "TForm build flag not set. Switch to \"OFF\".")
endif()
if(NOT DEFINED BUILD_PFORM)
    set(BUILD_PFORM OFF CACHE STRING "Enable build Parallel Form")
    message(NOTICE "PForm build flag not set. Switch to \"OFF\".")
endif()

if(NOT DEFINED WITH_FLOAT)
    set(WITH_FLOAT OFF CACHE STRING "Enable build with float support")
    message(NOTICE "Build option \"WITH_FLOAT\" is not set. Switch to \"OFF\".")
elseif(WITH_FLOAT)
    message(WARNING "Enable float support needs gmp library.")
    string(${WITH_FLOAT} TOUPPER ${WITH_FLOAT})
endif()
if(NOT DEFINED WITH_MODULEFILES)
    set(WITH_MODULEFILES OFF CACHE STRING "Enable build Modulefiles")
    message(NOTICE "Not generate Tcl EnvModules file.")
endif()
if(NOT DEFINED EXPORT_BUILDLOG)
    set(EXPORT_BUILDLOG ON CACHE STRING "Print build information in default")
    message(NOTICE "Export build details during build.")
endif()


# Process subdirectories.
add_subdirectory(sources)
