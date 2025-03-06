

# CMake package process CPack configuration cmake module.
# This CMake module will automatically invoked by CPack if CPack is included by CMake,
#   contains the wraping details, with different package generation on different OS.
#[[
        Windows: 
            By exectuable self-unpackage: 
                NSIS(Nullsoft Scriptable Install System):   *.exe
            By Wrapped-Up Package:
                ZIP compressed package                      *.zip
                7Zip Format compressed package              *.7z
                XZ Compressed Tarball                       *.tar.xz(default)
                GZIP Compressed tarball                     *.tar.gz
        Linux:
            By Package Manager:
                Debian/Ubuntu/Mint:                         *.deb
                Fedora/CentOS/RHEL/Rocky:                   *.rpm
                Arch:                                       *.pkg.tar.zst
            By Wrapped-Up Package:
                RAR ZIP compressed package                  *.zip
                RAR RAR compressed package                  *.rar
                7Zip Format compressed package              *.7z
                Singal Tarball package                      *.tar
                XZ Compressed Tarball                       *.tar.xz(default)
                GZIP Compressed tarball                     *.tar.gz
        macOS: 
            By Package:
                DND  -->  DragNDrop                         *.dmg
                PKG  -->  macOS Package                     *.pkg
                APP                                         *.app
            By Wrapped-Up Package:
                RAR ZIP compressed package                  *.zip
                RAR RAR compressed package                  *.rar
                7Zip Format compressed package              *.7z
                Singal Tarball package                      *.tar
                XZ Compressed Tarball                       *.tar.xz(default)
                GZIP Compressed tarball                     *.tar.gz

 ]]

# Before truly set CPack Generator, Check if fits ${CPack_Generator} STREQUAL ${OS_NAME}.
#   If fits "not" result, throw back a FATAL_ERROR. 
if( (${EXPORT_PACKAGE} MATCHES "^(DND|PKG|APP)$") AND (NOT ${APPLE}) )
    message(FATAL_ERROR "Your selected package ${EXPORT_PACKAGE} is not support on ${OS_NAME}.")
elseif( (${EXPORT_PACKAGE} STREQUAL "NSIS") AND (NOT ${WINDOWS}) )
    message(FATAL_ERROR "Nullsoft Scriptable Install System is only avail on Windows.")
endif()

# Package provider definition.
set(CPACK_PACKAGE_NAME "FORM")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "FORM")
set(CPACK_PACKAGE_VERSION_MAJOR ${FORM_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${FORM_MINOR_VERSION})
set(CPACK_PACKAGE_VERSION_PATCH ${FORM_PATCH_VERSION})
set(CPACK_PACKAGE_VENDOR "Vermaseren")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")
set(CPACK_VERBATIM_VARIABLES YES)

message(NOTICE "Check for exporting Form build to binary package.")
if(${EXPORT_PACKAGE} MATCHES "^(NO|No|no|Off|off|disable|skip)$")
    message(STATUS "Building package is disabled.")
elseif(${EXPORT_PACKAGE} MATCHES "^(ON|On|on|Yes|yes|default)$")
    set(CPACK_GENERATOR TXZ)
    message(STATUS "Selected default package output: XZ Tarball")
else()
    if(EXPORT_PACKAGE)
        if(${CYGWIN})
            set(CPACK_GENERATOR "Cygwin")
        endif()
    elseif(${EXPORT_PACKAGE} STREQUAL "TXZ")
        set(CPACK_GENERATOR TXZ)
    elseif(${EXPORT_PACKAGE} STREQUAL "TGZ")
        set(CPACK_GENERATOR TGZ)
    elseif(${EXPORT_PACKAGE} STREQUAL "7z")
        set(CPACK_GENERATOR 7Z)
        if(${WIN32})
            include(modules/FInd7Z.cmake)
        endif()
    elseif((${EXPORT_PACKAGE} STREQUAL "NSIS") AND ${WINDOWS})
        set(CPACK_GENERATOR NSIS)
        include(${FORM_CMAKE_UTILS}/modules/FindNSIS.cmake)
        
        set(CPACK_NSIS_COMPRESSOR "/SOLID lzma \r\n SetCompressorDictSize 32")
        set(CPACK_NSIS_MUI_ICON "${FORM_CMAKE_UTILS}/nikhef.ico")
        set(CPACK_NSIS_MUI_UNIICON "${FORM_CMAKE_UTILS}/nikhef.ico")
        set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")
            #set(CPACK_PACKAGE_ICON "${FORM_CMAKE_UTILS}/spiraal.bmp")
        if(NOT DEFINED CPACK_PACKAGE_INSTALL_REGISTRY_KEY)
            set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "FORM")
        endif()
        set(CPACK_NSIS_MODIFY_PATH ON)
        set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL "ON")
        if(${x64})
            if(NOT DEFINED CPACK_NSIS_INSTALL_ROOT)
                set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
            endif()
        endif()
    elseif( (${EXPORT_PACKAGE} STREQUAL "DND") AND (${APPLE}) )
        set(CPACK_GENERATOR "DragNDrop")
        set(CPACK_DMG_VOLUME_NAME "FORM")
    elseif( (${EXPORT_PACKAGE} STREQUAL "DND") AND (${APPLE}) )
        set(CPACK_GENERATOR "productbuild")
        set(CPACK_PRODUCTBUILD_IDENTIFIER "FORM")               # Kept FORM or Fix to original author Vermaseren
    elseif(${CPACK_GENERATOR} MATCHES "^(DEB|deb|Debian)$")
        set(CPACK_GENERATOR DEB)
    elseif(EXPORT_PACKAGE MATCHES "^(RPM|rpm)$")
        set(CPACK_GENERATOR RPM)
    else()
        message(WARNING "Unknown CPack Generator. Switch back to default.")
    endif()
endif()
message(CHECK_PASS "${EXPORT_PACKAGE}")
# We finally can wrappup the builds as redistributable.
include(CPack)