
# The compiler optimization for MSVC.
# Now MSVC /favor flag is avail on x64 for  AMD64 
#                                           Intel64
#                                           Intel Atom
#                                           IA64/Generic x86-64
#                                           EXT64 for 64bit Windows XP

if(DEFINED CACHE MSVC_FAVOR)
    if((CMAKE_CXX_COMPILER_ID MATCHES "MSVC") AND (${CMAKE_SYSTEM_PROCESSOR} MATCHES "AMD64"))
        if(${MSVC_FAVOR} MATCHES "favor")
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
        elseif(${MSVC_FAVOR} MATCHES "^(blend|generic)$")
            set(FAVOR_FLAGS "/favor:blend")
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FAVOR_FLAGS}")
            set(CMAKE_CXX_FLAGS "${FAVOR_FLAGS}")
            message(CHECK_PASS "${FAVOR_FLAGS}")
        endif()
    else()
        message(CHECK_FAIL "Settings Conflict")
        if(NOT (CMAKE_CXX_COMPILER_ID MATCHES "MSVC"))
            message(WARNING "The C/CXX compiler ${CMAKE_CXX_COMPILER_ID} is not support \"/favor\". CMake will unset this option.")
        endif()
        if(NOT (${CMAKE_SYSTEM_PROCESSOR} MATCHES "^(AMD64|x86)$"))
            message(WARNING "Target processor ${CMAKE_SYSTEM_PROCESSOR} is not support for MSVC /favor option. CMake will unset this option.")
        endif()
            unset(MSVC_FAVOR)
    endif()
else()
    message(CHECK_PASS "Not Set")
endif()