

# Check build system details 4 generating version.h.

message(CHECK_START "Identifying Build Target")
unset(UNIX)
unset(LINUX)
unset(BSD)

if($ENV{OSTYPE} MATCHES "msys")
    set(MSYS TRUE)
    execute_process(COMMAND uname -r
                    OUTPUT_VARIABLE MSYS2_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" MSYS2_VERSION ${MSYS2_VERSION})
    set(OS_NAME "MSYS2\-${MSYS2_VERSION}\($ENV{MSYSTEM}\)")
    set(OS_PROCESSOR "x86_64")
    message(CHECK_PASS "MSYS2 ${MSYS2_VERSION}")
elseif(CYGWIN)
    execute_process(COMMAND uname -r
                    OUTPUT_VARIABLE CYGWIN_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" CYGWIN_VERSION ${CYGWIN_VERSION})
    set(OS_NAME "Cygwin ${CYGWIN_VERSION}")
    if($ENV{PROCESSOR_ARCHITECTURE} STREQUAL "AMD64")
        set(OS_PROCESSOR "x86_64")
    else()
        set(OS_PROCESSOR "x86")
    endif()
    message(CHECK_PASS "Cygwin ${CYGWIN_VERSION}")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(WINDOWS TRUE)
    execute_process(COMMAND powershell "(Get-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion' -Name CurrentBuild).CurrentBuild"
                    OUTPUT_VARIABLE WINNT_BUILD
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    # Processing identify on Windows Feature Experience Version.
    if(WINNT_BUILD GREATER_EQUAL 22000)
        message(CHECK_PASS "Windows 11")
        set(OS_NAME "Win11")
    elseif((WINNT_BUILD GREATER_EQUAL 19000) AND (WINNT_BUILD LESS 20000))
        message(CHECK_PASS "Windows 10")
        set(OS_NAME "Win10")
    elseif((WINNT_BUILD GREATER_EQUAL 9200) AND (WINNT_BUILD LESS_EQUAL 9600))
        message(CHECK_PASS "Windows 8")
        set(OS_NAME "Win8")
    elseif((WINNT_BUILD EQUAL 7600) OR (WINNT_BUILD EQUAL 7601))
        message(CHECK_PASS "Windows 7")
        set(OS_NAME "Win7")
    elseif((WINNT_BUILD GREATER_EQUAL 6000) AND (WINNT_BUILD LESS_EQUAL 6002))
        message(CHECK_PASS "Windows Vista")
        set(OS_NAME "Win_Vista")
    elseif((WINNT_BUILD EQUAL 2600))
        message(CHECK_PASS "Windows XP")
        set(OS_NAME "WinXP")
    else()
        message(CHECK_FAIL "Legacy Windows")
        set(OS "Legacy Windows_NT")
    endif()
    # Processing identify on CPU vendor.
    if($ENV{PROCESSOR_IDENTIFIER} MATCHES "Intel64")
        set(OS_PROCESSOR "Intel64")
        set(x64 true)
    elseif($ENV{PROCESSOR_IDENTIFIER} MATCHES "AMD64")
        set(OS_PROCESSOR "AMD64")
        set(x64 true)
    elseif($ENV{PROCESSOR_ARCHITECTURE} MATCHES ("aarch64" OR "arm64" OR "Qualcomm"))
        set(OS_PROCESSOR "ARM64")
    elseif($ENV{PROCESSOR_ARCHITECTURE} MATCHES "x86")
        set(OS_PROCESSOR "x86")
        set(x86 TRUE)
    endif()

elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(LINUX TRUE)
    execute_process(COMMAND lsb_release -i
                    OUTPUT_VARIABLE LINUX_DISTRO_LSB_NAME
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REPLACE "Distributor ID:" "" LINUX_NAME ${LINUX_DISTRO_LSB_NAME})
    string(STRIP "${LINUX_NAME}" LINUX_NAME)

    execute_process(COMMAND lsb_release -r
                    OUTPUT_VARIABLE LINUX_DISTRO_LSB_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REPLACE "Release:" "" LINUX_VERSION ${LINUX_DISTRO_LSB_VERSION})
    string(STRIP "${LINUX_VERSION}" LINUX_VERSION)
    if(EXISTS "/proc/version")
        # Check for Linux Distrubution.
        file(READ "/proc/version" PROC_VERSION)
        if((EXISTS "/etc/wsl.conf") OR (PROC_VERSION MATCHES "microsoft-standard"))
            set(WSL2 TRUE)
            set(OS_NAME "${LINUX_NAME}-${LINUX_VERSION}(WSL2)")
            message(CHECK_PASS "${OS_NAME}")
        else()
            set(OS_NAME ${LINUX_DISTRO_NAME})
            message(CHECK_PASS "${OS_NAME} GNU/Linux")
        endif()
    endif()
elseif(ANDROID)   
        execute_process(COMMAND getprop "ro.build.version.release"
                        OUTPUT_VARIABLE ANDRIOD_VERSION
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
        set(OS_NAME "Android ${ANDRIOD_VERSION}")
        set(OS_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR})
        message(CHECK_PASS "${OS_NAME}")
elseif(APPLE)
    execute_process(COMMAND sw_vers -productVersion
                    OUTPUT_VARIABLE MACOS_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "arm64")
        set(OS_PROCESSOR "Apple Silicon")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "Intel")
        set(OS_PROCESSOR "Intel64")
    endif()
    set(MACOS_NAME "macOS ${MACOS_VERSION}")
    message(CHECK_PASS "Apple ${MACOS_NAME}(${OS_PROCESSOR})")
elseif($ENV{os_name} MATCHES "BSD")
    set(BSD TRUE)
    execute_process(COMMAND uname "-s"
                    OUTPUT_VARIABLE BSD_DISTRO_NAME
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND uname "-r | awk -F '[^0-9.]' '{print $1}'"
                    OUTPUT_VARIABLE BSD_DISTRO_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(OS_NAME "${BSD_DISTRO_NAME}-${BSD_DISTRO_VERSION}")
    set(OS_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR})
    message(CHECK_PASS "BSD ${OS_NAME}")

else()
    message(CHECK_FAIL "Failed")
endif()

if(${FORM_IS_BETA_VERSION})
    set(FORM_PATCH_VERSION "${FORM_PATCH_VERSION}${FORM_BETA_TAG}") 
endif()

# Setup If WINAPI is defined or not: Default set to POSIX.
    if(CYGWIN OR MSYS)
        if(NOT DEFINED WINAPI)
            set(WINAPI FALSE CACHE BOOL "Cygwin/MSYS2 build use Windows API")
        endif()
    else()
        unset(WINAPI)
    endif()
    if(LINUX OR APPLE OR BSD OR ANDROID OR UNIX)
        set(UNIX TRUE)
        set(API "POSIX")
    elseif((CYGWIN OR MSYS) AND NOT WINAPI)
        set(UNIX TRUE)
        set(API "POSIX")
    elseif((CYGWIN OR MSYS) AND WINAPI)
        set(WINDOWS_API TRUE)
        set(API "Windows")
    elseif(WIN32)
        set(WINDOWS_API TRUE)
        set(API "Windows")
    endif()


# Set COMPILER ID stamp.
#[[
        Check for Compiler ID as build stamp to startup.c.
        MSVC:                   Microsoft Optimized Visual C/C++ for Visual Studio
        GCC:                    GNU Compiler Collection C/C++
        Clang:                  LLVM Compiler Infastructure C/C++ language frontend
        AppleClang:             LLVM Compiler Infastructure C/C++ language frontend for Apple macOS
        Intel:                  Intel Classic C/C++ Compiler
        IntelLLVM:              Intel oneAPI DPC++/C++ with LLVM backend
        NVIDIA/PGI:             NVIDIA HPC SDK (> 20.7)/Portland Group HPC Compiler(<=20.4)
        Borland:                Borland C/C++ Compiler (Legacy <= 5.5)
        Embarcadero:            Borland C/C++ Compiler with LLVM backend (Embarcadero >= 6)
        OrangeC:                LADSoft open-sourced Orange C Compiler
 ]]

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(COMPILER_NAME "MSVC-v${MSVC_TOOLSET_VERSION}")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    execute_process(COMMAND ${CMAKE_CXX_COMPILER} "-dumpversion"
                    OUTPUT_VARIABLE GCC_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(COMPILER_NAME "GCC-${GCC_VERSION}")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "LLVM")
    execute_process(COMMAND ${CMAKE_CXX_COMPILER} "-dumpversion"
                    OUTPUT_VARIABLE CLANG_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(COMPILER_NAME "Clang-${CLANG_VERSION}")
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Apple")
    execute_process(COMMAND ${CMAKE_CXX_COMPILER} "-dumpversion"
                    OUTPUT_VARIABLE CLANG_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(COMPILER_NAME "Apple-Clang-${CLANG_VERSION}")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
    if(${LINUX})
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} "-dumpversion"
                        OUTPUT_VARIABLE DPCPP_VERSION
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
        set(COMPILER_NAME "IntelDPC++_${DPCPP_VERSION}")
    elseif(${WINDOWS})
        set(COMPILER_NAME "IntelDPC++")
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    if(${LINUX})
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} "-dumpversion"
                        OUTPUT_VARIABLE DPCPP_VERSION
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
        set(COMPILER_NAME "IntelC++_${DPCPP_VERSION}")
    elseif(${WINDOWS})
        set(COMPILER_NAME "IntelC++")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "^(NVHPC|PGI)$")
    execute_process(COMMAND ${CMAKE_CXX_COMPILER} "-dumpversion"
                    OUTPUT_VARIABLE NVHPC_VERSION
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(COMPILER_NAME "NVIDIA/PGI-${NVHPC_VERSION}")
else()
    set(COMPILER_NAME ${CMAKE_CXX_COMPILER_ID})
endif()

# Set Definitions on "Debug;Release/MinSizeRel."
# Here, We(me) deprecated from modifying "CMAKE_C/CXX_FLAGS" to
#   using add/remove_definition to pass debugging flags.
# [Tueda]
        # Debugging flag.
    # set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUGGING")
    # set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUGGING")

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    remove_definitions(-DNDEBUG)            # If cmake initial guess "-DNDEBUG" for global, remove it.
    add_definitions(-DDEBUGGING)
elseif(${CMAKE_BUILD_TYPE} MATCHES "^(Release|MinSizeRel)$")
  # add_definitions(-DNDEBUG)
endif()

# Print out verbose build details.
set(VERSION_FILE "${PROJECT_BINARY_DIR}/version.h")
file(WRITE "${VERSION_FILE}"
    "#define REPO_MAJOR_VERSION ${FORM_MAJOR_VERSION}\n"
    "#define REPO_MINOR_VERSION ${FORM_MINOR_VERSION}\n"
    "#define REPO_PATCH_VERSION ${FORM_PATCH_VERSION}\n"
    "#define REPO_BUILD_OS      ${OS_NAME}\n"
    "#define REPO_BUILD_ARCH    ${OS_PROCESSOR}\n"
    "#define REPO_BUILD_TYPE    ${CMAKE_BUILD_TYPE}\n"
    "#define REPO_BUILD_COMPILER ${COMPILER_NAME} "
)
add_definitions(-DCMAKE_VERBOSE_BUILDSTAMP)

# Hidden Level.
if(NOT DEFINED NOVERBOSESTAMP)
    set(NOVERBOSESTAMP OFF CACHE BOOL "Disable verbose stamp" FORCE)
elseif(${NOVERBOSESTAMP})
    message(STATUS "Disabled Verbose Stamp")
    remove_definitions(-DCMAKE_VERBOSE_BUILDSTAMP)
endif()

