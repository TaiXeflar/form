

#[[ ========== Optimization Console =========  ]]

# original: follows the autoconf rules.
# default: follows the cmake guess.
# favor: activate optimization on /favor:<CPU> microarchitectures with MSVC.
# 
#


if(OPTIMIZE MATCHES "^(pass|skip|disable|ignore)$")
    # Run Default CMake guess and do nothing.
elseif(OPTIMIZE MATCHES "^(autoconf|gcc3)$")
    if(${UNIX})
        # Reset C/C++ compiler flags if UNIX platform with gcc/g++ or clang/clang++.
        # Define compile flags from DEPMODE=gcc3.

    else()
        message(FATAL_ERROR "Your build environment not support autoconf setup macros. Please Re-Configure it.")
    endif()
elseif(OPTIMIZE STREQUAL "favor")
    if(${MSVC})
        if($ENV{PROCESSOR_IDENTIFIER} MATCHES "Intel64")
            set(FAVOR_FLAGS "/favor:INTEL64")
        elseif($ENV{PROCESSOR_IDENTIFIER} MATCHES "AMD64")
            set(FAVOR_FLAGS "/favor:AMD64")
        elseif($ENV{PROCESSOR_ARCHITECTURE} MATCHES "EM64T")
            set(FAVOR_FLAGS "/favor:EN64T")
            set(OS_NAME "Windows XP (64-bit)")
        elseif($ENV{PROCESSOR_ARCHITECTURE} MATCHES "^(Atom|ATOM)")
            set(FAVOR_FLAGS "/favor:ATOM")
        endif()
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FAVOR_FLAGS}")
        set(CMAKE_CXX_FLAGS "${FAVOR_FLAGS}")
        message(CHECK_PASS "${FAVOR_FLAGS}")
    else()
        message(FATAL_ERROR " -D OPTIMIZE=\"favor\" option is for MSVC only.")
    endif()
elseif(OPTIMIZE STREQUAL "generic")
    if(${MSVC} AND (${x64} OR ${x86}))
        message("\tSelected MSVC favor optimize for generic x86/x64.")
        set(FAVOR_FLAGS "/favor:blend")
        message(CHECK_PASS "${OPTIMIZE}: Blend")
    else()
        message(FATAL_ERROR " -- Fatal Error: -D OPTIMIZE=\"favor\" option is for MSVC only.")
    endif()
elseif()
    message(FATAL_ERROR "Unknown optimization. Please run \"cmake -P cmake/help.cmake\" for enabled options.")
endif()



