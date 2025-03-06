

#[[  ========    Working Directory    ========  ]]

#[[
        Here, I'm doing my best but cannot duplicate a same mode to command similar as check.rb does.

        The actuall works CTest here is run ALL test and returns a exit code 0 as success pass the test.
        Tested successful on WSL2 ans Cygwin.
 ]]


include(CTest)
include(../cmake/modules/FindRubyTestUnit.cmake)

set(RUBY_TEST_SCRIPT ${CMAKE_SOURCE_DIR}/check/check.rb)


if(${BUILD_FORM})
    set(FORM_TARGET_BIN ${CMAKE_BINARY_DIR}/sources/form)
    add_test(NAME FORM
             COMMAND ${RUBY_TEST_SCRIPT} ${FORM_TARGET_BIN})
endif()
if(${BUILD_TFORM})
    set(TFORM_TARGET_BIN ${CMAKE_BINARY_DIR}/sources/tform)
    add_test(NAME TFORM
             COMMAND ${RUBY_TEST_SCRIPT} ${TFORM_TARGET_BIN})
    set_tests_properties(TFORM PROPERTIES PROCESSORS 4)
endif()
if(${BUILD_PFORM})
    set(PFORM_TARGET_BIN ${CMAKE_BINARY_DIR}/sources/pform)
    add_test(NAME PFORM
             COMMAND ${RUBY_TEST_SCRIPT} ${PFORM_TARGET_BIN} ${TEST_FRM_FILE})
    set_tests_properties(PFORM PROPERTIES PROCESSORS 4)
endif()

#[[     
        [==== TaiXeflar ====]

        Actually this part is unexpected harder and let me kinda a little frustrated. 

        My Goal is make a duplicate the same command-line like:

            from:   check.rb ${BUILD_FORM_EXE} ${TEST_FORM_SCRIPT_BASENAME}.frm -D TEST=XXX
            to:     ctest ${BUILD_FORM_EXE} -DTESTING=${TEST_FORM_SCRIPT_BASENAME}/${TEST_FORM_SCRIPT_EXAMPLE}

        For example: (The ideal command line contains less chars)

            from:   check.rb ../form ./user.frm -D TEST=tueda_prf_1
            to:     ctest FORM -DTESTING=user/tueda_prf_1       

            from:   check.rb ../form
            to:     ctest FORM

        I'm trying to set FORM/TFORM/PFORM as test target(defined and configured in CMake), then use ctest command with Cache entry to
            split the frm file and test part to execute test command by check.rb. With a pesudo code here:

            add_test( NAME ${SELECTED_FORM_NAME}
                      COMMAND ${RUBY_SCRIPT} "${SELECTED_FORM_COMPILER_NAME} ${CACHE_ENTRY_SPLITED_FORM_FILE} -D TEST=${TEST_PART}"
            )   

            add_test( NAME FORM
                      COMMAND check.rb form user.frm -D TEST=tueda_prf_1)

        I'm getting problem is we can't define it(FORM/TFORM/PFORM test in CMake, -DTESTING=... in ctest) from two different command line,
            or one side will have something not defined and gets cmake error. The most close achieve ways is,
            build a custom test cmake script running ctest as script mode and seems too complexed. this is doesn't what I wanted.

            (ctest -S)/(cmake -P) run_test.cmake -DTEST_FORM_EXE=form -DTEST_FILE=user.frm -DTEST_PART=tueda_prf_1

        Anyway, I'll working on other ways to achieve this.

        And maybe can find me in Teyvat(Maybe Inazuma/Fontaine) or XianZhou-Luofu/Penacony somewhere(lol).
 ]]