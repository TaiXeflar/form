# Generate config.h.

# By
set(CONFIG_FILE "${PROJECT_SOURCE_DIR}/sources/config-cmake.h.in")
file(WRITE ${CONFIG_FILE}
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
include_directories("${PROJECT_BINARY_DIR}")
configure_file(
  "${PROJECT_SOURCE_DIR}/sources/config-cmake.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
)
add_definitions(-DHAVE_CONFIG_H)

# Generate version.h.  ---> Experimental version control define in CMakeLists.txt.
set(VERSION_FILE "${PROJECT_BINARY_DIR}/version.h")
file(WRITE "${VERSION_FILE}"
    "#define REPO_MAJOR_VERSION ${FORM_MAJOR_VERSION}\n"
    "#define REPO_MINOR_VERSION ${FORM_MINOR_VERSION}\n"
    "#define REPO_PATCH_VERSION ${FORM_PATCH_VERSION}\n"
    "#define REPO_BUILD_OSNAME  ${CMAKE_SYSTEM_NAME}\n"
    "#define REPO_BUILD_ARCH    ${CMAKE_SYSTEM_PROCESSOR}\n"
    "#define REPO_BUILD_TYPE    ${CMAKE_BUILD_TYPE}\n"
)
include_directories("${PROJECT_BINARY_DIR}/sources")

# Debugging flag.

#set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUGGING")
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUGGING")


# % TaiXeflar
# Targeting source files that is included all in sources file.

file(GLOB form_SOURCES  ${CMAKE_CURRENT_SOURCE_DIR}/*.c 
                        ${CMAKE_CURRENT_SOURCE_DIR}/*.cc)

#  Exclude not on listed from original makefile.am. If file is addedd to compile just remove it in below.
## Also adding compile error sources files here to temporary exclude it.
## Also set source file to by flow control to re-add files.
list(REMOVE_ITEM form_SOURCES 
                                ${CMAKE_CURRENT_SOURCE_DIR}/bugtool.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/evaluate.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/float.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/gentopo.cc
                                ${CMAKE_CURRENT_SOURCE_DIR}/topowrap.cc
                                ${CMAKE_CURRENT_SOURCE_DIR}/unixfile.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/unix.h
                                ${CMAKE_CURRENT_SOURCE_DIR}/fwin.h
                                ${CMAKE_CURRENT_SOURCE_DIR}/threads.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/mpi.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/mpidbg.h
                                ${CMAKE_CURRENT_SOURCE_DIR}/parallel.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/parallel.h
)

if(UNIX) ## Check if Unix-Like Systems.
    list(APPEND form_SOURCES    ${form_SOURCES} 
                                ${CMAKE_CURRENT_SOURCE_DIR}/unixfile.c
    )
elseif(WINDOWS)
    list(APPEND form_SOURCES    ${form_SOURCES}
                                ${CMAKE_CURRENT_SOURCE_DIR}/fwin.h
    )
else()
endif()

if(WITH_FLOAT)
    list(APPEND form_SOURCES    ${form_SOURCES}
                                ${CMAKE_CURRENT_SOURCE_DIR}/evaluate.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/
    )
endif()


# % TaiXeflar
# Building selected executables.

if(${BUILD_FORM})
    add_executable(form ${form_SOURCES})
endif()
if(BUILD_TFORM) ## If TForm is selected
    set(tform_SOURCES ${form_SOURCES}    ${CMAKE_CURRENT_SOURCE_DIR}/threads.c)
    add_executable(tform ${tform_SOURCES})
endif()
if(BUILD_PFORM) ## If paraForm is selected (Here replace parform as pform)
    set(pform_SOURCES   ${form_SOURCES} ${CMAKE_CURRENT_SOURCE_DIR}/mpi.c
                                        ${CMAKE_CURRENT_SOURCE_DIR}/parallel.c)      
    add_executable(pform ${pform_SOURCES})
endif()


if(${WITH_MODULEFILES})
    set(MODULE_FILE "${CMAKE_BINARY_DIR}/form_${FORM_MAJOR_VERSION}.${FORM_MINOR_VERSION}.${FORM_PATCH_VERSION}")
    file(WRITE ${MODULE_FILE}
        "set FORM_HOME ${CMAKE_INSTALL_PREFIX}\n\n"
        "prepend-path PATH $FORM_HOME/bin\n"
        "prepend-path MANPATH $FORM_HOME/man"
    )
endif()

if(${BUILDINFO_FILE})
    set(BUILDINFO_FILE "BuildInfo.txt")
    file(WRITE ${CMAKE_BINARY_DIR}/${BUILDINFO_FILE}
        "Building Form version:     ${FORM_MAJOR_VERSION}.${FORM_MINOR_VERSION}.${FORM_PATCH_VERSION}
         Build Platform:            ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_HOST_SYSTEM_VERSION} ${CMAKE_HOST_SYSTEM_PROCESSOR}
         Build Target:              ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} ${CMAKE_SYSTEM_PROCESSOR}
         Build Type:                ${CMAKE_BUILD_TYPE}
         BUILD Info:

            CMAKE_VERSION:          ${CMAKE_VERSION}
            CMAKE_C_COMPILER:       ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_ARCHITECTURE_ID} ${CMAKE_C_COMPILER_VERSION}
            CMAKE_CXX_COMPILER:     ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_ARCHITECTURE_ID} ${CMAKE_CXX_COMPILER_VERSION}
            CMAKE_GENERATOR:        ${CMAKE_GENERATOR}

            FORM:                   ${BUILD_FORM}
            TFORM:                  ${BUILD_TFORM}
            PFORM:                  ${BUILD_PFORM}
            WITH_FLOAT:             ${WITH_FLOAT}
            WITH_MODULEFILES:       ${WITH_MODULEFILES}
        "
    )
endif()

# install targets.
if(BUILD_FORM)
    install(TARGETS form DESTINATION bin)
elseif(BUILD_TFORM)
    install(TARGETS tform DESTINATION bin)
elseif(BUILD_PFORM)
    install(TARGETS pform DESTINATION bin)
elseif(WITH_MODULEFILES)
    install(FILES ${MODULE_FILE} DESTINATION share/modulefiles/form/)
elseif(BUILDINFO_FILE)
    install(FILES ${BUILDINFO_FILE} DESTINATION share)
endif()

install(
    FILES           "${CMAKE_SOURCE_DIR}/COPYING" 
    DESTINATION     share/license/
)
install(
    FILES           "${CMAKE_SOURCE_DIR}/doc/form.1" 
    DESTINATION     share/man/man1/
)