

# Find where local Machine have 7-Zip compressor.


if(${WINDOWS})
    execute_process(COMMAND powershell -Command "Get-ItemProperty -Path 'HKLM:\\SOFTWARE\\7-zip' -Name 'Path' | Select-Object -ExpandProperty Path"
                    OUTPUT_VARIABLE 7Z_DIR
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()
find_program(MAKE_7Z
    NAMES 7z
    PATHS ${7Z_DIR})
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(7Z DEFAULT_MSG MAKE_7Z)

if(MAKE_7Z)
    set(7Z_FOUND TRUE)
endif()
mark_as_advanced(MAKE_7Z)