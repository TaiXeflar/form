

# Replica of Autoconf CC/CXXDEPMODE.

# Try to make a similar compile flag set for GNU gcc and "Clang with GNU-Like command line".

if(DEFINED DEPMODE)
    if((${CMAKE_CXX_COMPILER_ID} MATCHES "^(GNU|Clang|LLVM)$") AND (NOT ${MSVC}))
        if(${DEPMODE} MATCHES "gcc3")
            set(FORM_COMPILE_FLAGS "-Wall -Wextra -Wno-misleading-indentation -Wno-stringop-overflow" 
            STRING "Form specified CC/CXXDEPMODE=gcc3 Compiler Flags")
            if(CMAKE_BUILD_TYPE MATCHES "Debug")
                set(CMAKE_C_FLAGS_DEBUG "${FORM_COMPILE_FLAGS} -Og -g3")
                set(CMAKE_CXX_FLAGS_DEBUG "${FORM_COMPILE_FLAGS} -Og -g3")
            elseif(CMAKE_BUILD_TYPE MATCHES "Release")
                set(CMAKE_C_FLAGS_RELEASE "${FORM_COMPILE_FLAGS} -O3 -fomit-frame-pointer -march=native")
                set(CMAKE_CXX_FLAGS_RELEASE "${FORM_COMPILE_FLAGS} -O3 -fomit-frame-pointer -march=native")
            elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
                set(CMAKE_C_FLAGS_RELWITHDEBINFO "${FORM_COMPILE_FLAGS} -O2 -fomit-frame-pointer -march=native")
                set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${FORM_COMPILE_FLAGS} -O2 -fomit-frame-pointer -march=native")
            elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
                set(CMAKE_C_FLAGS_MINSIZEREL "${FORM_COMPILE_FLAGS} -Os -fomit-frame-pointer -march=native")
                set(CMAKE_CXX_FLAGS_MINSIZEREL "${FORM_COMPILE_FLAGS} -Os -fomit-frame-pointer -march=native")
            endif()
            message(CHECK_PASS "gcc3 CC/CXXDepmode")
            # Can add other compiler CC/CXXDEPMODE configure settings like AIX at below.
            #[[
                if(${DEPMODE} MATCHES "aix")
                    ......
                endif()
            ]]
        elseif(${DEPMODE} MATCHES "(skip|no)")
            message(CHECK_PASS "CC/CXXDepmode OFF")
        endif()
    else()
        message(CHECK_FAIL "Settings Conflict")
        message(WARNING "The C/CXX compiler ${CMAKE_CXX_COMPILER_ID} is not support \"DEPMODE\". CMake will unset this option.")
        unset(DEPMODE)
    endif()
else()
    message(CHECK_PASS "Not Set")
endif()
