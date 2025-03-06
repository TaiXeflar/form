
# Add CMake Policy for cmake behavior changes.

cmake_policy(SET CMP0000 NEW)  
    # CMake projects requires `cmake_minimum_repuired(VERSION <MIN> .....)` in the head part of Top-Level CMakeLists.txt.
    
cmake_policy(SET CMP0012 NEW)
    #CMP0012 NEW encourage users to set CMake policy where if condition must have variable expanded inside. 

cmake_policy(SET CMP0048 NEW)
    # Set CMake policy where project() have params 'VERSION' defined.

cmake_policy(SET CMP0025 NEW)
cmake_policy(SET CMP0047 NEW)
cmake_policy(SET CMP0089 NEW)
    # Set CMake policy where COMPILER_ID is ensured to write into the buildstamp.