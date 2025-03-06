

# Find where local Windows Machine have Nullsoft Scriptable Install System(NSIS).
# NSIS use *.nsh script to generate exetuable with install process and registry.

execute_process(COMMAND powershell -Command "(Get-ItemProperty -Path 'HKLM:/SOFTWARE/WOW6432Node/NSIS' -Name '(Default)') | Select-Object -ExpandProperty '(Default)' "
                    OUTPUT_VARIABLE NSIS_INSTALL_DIR
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NSIS_INCLUDES)
    set(NSIS_FIND_QUIETLY FALSE)
endif()

find_program(MAKE_NSIS
    NAMES makensis
    PATHS ${NSIS_INSTALL_DIR})
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NSIS DEFAULT_MSG MAKE_NSIS)

if(MAKE_NSIS)
    set(NSIS_FOUND TRUE)
endif()
mark_as_advanced(MAKE_NSIS)