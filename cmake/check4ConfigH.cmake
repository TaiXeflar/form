

# TaiXeflar
# Generates Config.h. 

set(CONFIG_FILE "${CMAKE_BINARY_DIR}/config-cmake.h.in")
file(WRITE ${CONFIG_FILE}
    # [Tueda]
    "#cmakedefine UNIX\n"
    "#cmakedefine WINDOWS\n\n"

    "#cmakedefine LINUX\n\n"

    "#cmakedefine ILP32\n"
    "#cmakedefine LLP64\n"
    "#cmakedefine LP64\n\n"

    "#ifndef __cplusplus\n"
    "#cmakedefine inline ${inline}\n"
    "#endif\n\n"

    "#cmakedefine HAVE_BOOST_UNORDERED_MAP_HPP\n"
    "#cmakedefine HAVE_BOOST_UNORDERED_SET_HPP\n"
    "#cmakedefine HAVE_TR1_UNORDERED_MAP\n"
    "#cmakedefine HAVE_TR1_UNORDERED_SET\n"
    "#cmakedefine HAVE_UNORDERED_MAP\n"
    "#cmakedefine HAVE_UNORDERED_SET\n"
)
include_directories("${CMAKE_BINARY_DIR}")
configure_file(
  "${CMAKE_BINARY_DIR}/config-cmake.h.in"
  "${CMAKE_BINARY_DIR}/config.h"
)
add_definitions(-DHAVE_CONFIG_H)