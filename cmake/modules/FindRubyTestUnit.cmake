

# CMake modules: Find Ruby and Ruby gem "Test/Unit."

find_package(RUBY REQUIRED)

if(${RUBY_VERSION} VERSION_LESS 1.9)
    message(FATAL_ERROR "Your RUBY version is ${RUBY_VERSION} Less then Required 1.9. Please update Ruby version.")
endif()

execute_process(
    COMMAND ${RUBY_EXECUTABLE} -e "begin; require 'test/unit'; puts Gem.loaded_specs['test-unit'].version; rescue LoadError; puts 'NOT_FOUND'; end"
    OUTPUT_VARIABLE RUBY_TEST_UNIT_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if (NOT RUBY_TEST_UNIT_VERSION STREQUAL "NOT_FOUND")
    set(RUBY_TEST_UNIT_FOUND TRUE)
else()
    set(RUBY_TEST_UNIT_FOUND FALSE)
endif()

mark_as_advanced(RUBY_TEST_UNIT_VERSION)
    
