

# Imports cmake modules for generate config.h
include(../cmake/check4ConfigH.cmake) # >>> Generate for config.h 

# Check for if Optimize option is active.
message(CHECK_START "Check for optimized options")
if((NOT DEFINED MSVC_FAVOR) AND (NOT DEFINED DEPMODE))
    message(CHECK_PASS "Not Set")
elseif(${CMAKE_CXX_COMPILER_ID} MATCHES "MSVC")
    include(../cmake/optim4MSVC.cmake)
elseif(NOT (${CMAKE_CXX_COMPILER_ID} MATCHES "MSVC"))
    include(../cmake/optim4GCC.cmake)
endif()

include_directories("${CMAKE_BINARY_DIR}/sources")

# Tueda
# Here's the part from Tueda's design, reading the Makefile.am to define compile objects.
function(read_automake_source begin_tag output_variable)
    # Read source files from the Makefile.am.
    file(STRINGS "${PROJECT_SOURCE_DIR}/sources/Makefile.am" text)
    set(files)
    foreach(line ${text})
    if("${line}" MATCHES "${begin_tag}")
        set(files ${line})
        break()
    endif()
    endforeach()
    string(REGEX REPLACE ".*=" "" files "${files}")
    string(REGEX REPLACE "[;\t\n\\]" " " files "${files}")
    string(REGEX REPLACE "[^ ]*\\.h" "" files "${files}")
    string(REGEX REPLACE "  +" " " files "${files}")
    string(STRIP "${files}" files)
    string(REGEX REPLACE " " ";" files "${files}")
    set("${output_variable}" "${files}" PARENT_SCOPE)
endfunction()
    
read_automake_source("SRCBASE" FORM_SRCBASE)

read_automake_source("SRCPTHREAD" TFORM_FILE)
read_automake_source("SRCPARALLEL" PFORM_FILE)

# % TaiXeflar
#[[
    # Targeting source files that is included all in sources file by using list  
    #       manually define compile objects.
    # Declare source file by use file(GLOB). Experimental cmake build command block.

    #  Exclude not on listed from original `makefile.am`. If file is addedd to compile just remove it in `list(REMOVE_ITEM ..)`.
    ## Also adding compile error sources files here to temporary exclude it.
    ## Also set source file to by flow control to re-add files.

    file(GLOB FORM_SRCBASE          ${CMAKE_CURRENT_SOURCE_DIR}/*.c 
                                    ${CMAKE_CURRENT_SOURCE_DIR}/*.cc)

    list(REMOVE_ITEM FORM_SRCBASE 
                                    ${CMAKE_CURRENT_SOURCE_DIR}/bugtool.c
                                    ${CMAKE_CURRENT_SOURCE_DIR}/evaluate.c          # -D WITH_FLOAT
                                    ${CMAKE_CURRENT_SOURCE_DIR}/float.c             # -D WITH_FLOAT
                                    ${CMAKE_CURRENT_SOURCE_DIR}/gentopo.cc
                                    ${CMAKE_CURRENT_SOURCE_DIR}/topowrap.cc
                                    ${CMAKE_CURRENT_SOURCE_DIR}/unixfile.c          # POSIX API
                                    ${CMAKE_CURRENT_SOURCE_DIR}/unix.h              # POSIX API
                                    ${CMAKE_CURRENT_SOURCE_DIR}/fwin.h              # WINDOWS_API
                                    ${CMAKE_CURRENT_SOURCE_DIR}/threads.c           # tform
                                    ${CMAKE_CURRENT_SOURCE_DIR}/mpi.c               # pform
                                    ${CMAKE_CURRENT_SOURCE_DIR}/mpidbg.h            # pform
                                    ${CMAKE_CURRENT_SOURCE_DIR}/parallel.c          # pform 
                                    ${CMAKE_CURRENT_SOURCE_DIR}/parallel.h          # pform
    )
    list(APPEND TFORM_SRCBASE ${FORM_SRCBASE}
                                threads.c)
    list(APPEND PFORM_SRCBASE ${FORM_SRCBASE}
                                mpi.c
                                mpidbg.h
                                parallel.c
                                parallel.h)
]]

if(${UNIX}) ## Check if Requires POSIX Standard Systems.
    list(APPEND FORM_SRCBASE    ${FORM_SRCBASE} 
                                ${CMAKE_CURRENT_SOURCE_DIR}/unixfile.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/unix.h
    )
elseif(${WINDOWS_API}) ## Else if Windows platform.
    list(APPEND FORM_SRCBASE    ${FORM_SRCBASE}
                                ${CMAKE_CURRENT_SOURCE_DIR}/fwin.h
    )
endif()
if(${WITH_FLOAT})      ## Add files for float features.
    list(APPEND FORM_SRCBASE    ${FORM_SRCBASE}
                                ${CMAKE_CURRENT_SOURCE_DIR}/evaluate.c
                                ${CMAKE_CURRENT_SOURCE_DIR}/float.c
    )
    include_directories(${GMP_INCLUDE_DIR} ${MPFR_INCLUDE_DIR})
endif()


# % TaiXeflar
# Building selected executables.
if(${BUILD_FORM})
    add_executable(form ${FORM_SRCBASE})
    list(APPEND FORM_TARGET_LIST form)
    if(${WITH_ZLIB})
        target_link_libraries(form ${ZLIB_LIBRARIES})
    endif()
    if(${WITH_ZSTD})
        target_link_libraries(form ${ZSTD_LIBRARIES})
    endif()
    if(${WITH_GMP})
        target_link_libraries(form ${GMP_LIBRARIES})
    endif()
    if(${WITH_MPFR})
        target_link_libraries(form ${MPFR_LIBRARIES})
    endif()
endif()

if(${BUILD_TFORM}) ## If TForm is selected
    set(tform_SOURCES   ${FORM_SRCBASE} ${TFORM_FILE})
    add_executable(tform ${tform_SOURCES})
    list(APPEND FORM_TARGET_LIST tform)
    target_compile_definitions(tform PUBLIC -DWITHPTHREADS)
    if(${UNIX})
        target_link_libraries(tform PUBLIC ${CMAKE_THREAD_LIBS_INIT})
    endif()
    if(${WINDOWS})
        target_include_directories(tform PUBLIC ${PTHREADS4W_INCLUDE_DIR})
        target_link_libraries(tform PUBLIC ${PTHREADS4W_LIBRARIES})
    endif()

    if(${WITH_ZLIB})
        target_link_libraries(tform PUBLIC ${ZLIB_LIBRARIES})
    endif()
    if(${WITH_ZSTD})
        target_link_libraries(tform PUBLIC ${ZSTD_LIBRARIES})
    endif()
    if(${WITH_GMP})
        target_link_libraries(tform PUBLIC ${GMP_LIBRARIES})
    endif()
    if(${WITH_MPFR})
        target_link_libraries(tform PUBLIC ${MPFR_LIBRARIES})
    endif()
endif()

if(${BUILD_PFORM}) ## If parform is selected (Here replace parform as pform)
    set(PFORM_SRCBASE   ${FORM_SRCBASE} ${PFORM_FILE})
    add_executable(pform ${PFORM_SRCBASE})
    list(APPEND FORM_TARGET_LIST pform)
    target_compile_definitions(pform PUBLIC -DWITHMPI
                                     PUBLIC -DPF_WITHGETENV
                                     PUBLIC -DPF_WITHLOG)
    target_include_directories(pform PUBLIC ${MPI_INCLUDE_PATH})
    target_link_libraries(pform PUBLIC ${MPI_LIBRARIES})
    if(${WITH_ZLIB})
        target_link_libraries(pform PUBLIC ${ZLIB_LIBRARIES})
    endif()
    if(${WITH_ZSTD})
        target_link_libraries(pform PUBLIC ${ZSTD_LIBRARIES})
    endif()
    if(${WITH_GMP})
        target_link_libraries(pform PUBLIC ${GMP_LIBRARIES})
    endif()
    if(${WITH_MPFR})
        target_link_libraries(pform PUBLIC ${MPFR_LIBRARIES})
    endif()
endif()

# Generates CEA-HPC/modules tclsh based Environment Modules modulefile.
if(${WITH_MODULES})
    set(MODULE_FILE "${CMAKE_BINARY_DIR}/form_${FORM_MAJOR_VERSION}.${FORM_MINOR_VERSION}.${FORM_PATCH_VERSION}")
    file(WRITE ${MODULE_FILE}
        "set FORM_HOME ${CMAKE_INSTALL_PREFIX}\n\n"
        "prepend-path PATH $FORM_HOME/bin\n"
        "prepend-path MANPATH $FORM_HOME/man")
endif()

# install targets.
install(TARGETS ${FORM_TARGET_LIST}
        RUNTIME DESTINATION bin)
if(${BUILD_PFORM})
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_INSTALL_PREFIX}/bin/pform ${CMAKE_INSTALL_PREFIX}/bin/parform)") # [[ Keep parform name ]])
endif()
if(${WITH_MODULES})
    install(FILES ${MODULE_FILE} DESTINATION share/modulefiles/form/)
endif()
if(${BUILDLOG})
    install(FILES ${BUILDINFO_FILE} DESTINATION share/)
endif()
install(FILES "${CMAKE_SOURCE_DIR}/COPYING" DESTINATION share/license/)
install(FILES "${CMAKE_SOURCE_DIR}/doc/form.1" DESTINATION share/man/man1/)

# Generate CMake Config files for Any possiable CMake task finds FORM project.
configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/templates/CMakeConfigForm.cmake.in"
    "${CMAKE_BINARY_DIR}/FormConfig.cmake"
     @ONLY)
install(FILES "${CMAKE_BINARY_DIR}/FormConfig.cmake"
        DESTINATION lib/cmake/Form)

# Add CPack for Form executable packaging support.
message(CHECK_START "Check for building package")
if(NOT DEFINED EXPORT_PACKAGE)
    message(CHECK_PASS "Skip")
else()
    include(../cmake/check4CPack.cmake)
endif()

# Add Phony Target Uninstall.
if(NOT TARGET uninstall)
    configure_file(
      "${CMAKE_SOURCE_DIR}/cmake/templates/CMakeUninstall.cmake.in"
      "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
      IMMEDIATE @ONLY)
  
    add_custom_target(uninstall
      COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
  endif()


#[[
    Warning: Using Ruby test/unit as CTest may unstable that could not work on Win64 or all platform else.
    This part is mentioned by comments and may need a fix.
#]]

# Add CTest.
message(CHECK_START "Check for Ruby Test")
if(NOT DEFINED RUBY_TEST)
    set(RUBY_TEST OFF CACHE BOOL "Enable run Ruby test/unit")
    message(CHECK_PASS "Skip")
elseif(NOT ${RUBY_TEST})
    message(CHECK_PASS "NO")
elseif(${RUBY_TEST})
    include(../cmake/check4CTest.cmake)
    message(CHECK_PASS "Yes")
endif()

