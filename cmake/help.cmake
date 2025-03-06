
cmake_policy(SET CMP0012 NEW)
message(NOTICE "

                        [========        CMake help        ========]
    General CMake help command: Shows calling CMake in command line usage.
    Command: \"cmake -H, -h, -help, --help, /?\"

    About this repo's self options hint, run CMake in script mode call help.cmake:
    Command: \"cmake -P (IF_HAVE_RELATIVE_PATH)/cmake/help.cmake\"

                    [========        CMake configuration        ========]
    CMake configuration command:
    \"cmake -S <SOURCE_DIR> -B <BUILD_FILE_DIR> -G <CMAKE_GENERATOR> -D<CMAKE_CACHE_NAME>=<CMAKE_CACHE_VAL> -D... \"

        Symbol\"(default=<VAL>)\" gives default set value.
        Symbol\"[]\" hints the value type.
        Symbol\"{}\" hints Case sensitive/insensitive.
        [BOOL]               Boolean Value are case insensitive, with True/On/Yes/Y/1 vs False/Off/No/n/0.
        [PATH/string]        Path value is Case sensitive; or if is Case insensitive in powershell/pwsh(\"Sometimes\").

    [Basic cmake set options]
    -S [PATH]
        Specify Project root path contains with CMakeLists.txt.
        If this is not defined, CMake will find first \"path like string\" in command line.
        Else if CMake not find any path, CMake will set the current location as CMake source root dir.
    -B [PATH]
        Specify generated build files path.
        If this is not defined, CMake will find second \"path like string\" in command line.
        Else if CMake not find any path, CMake will set the current location as CMake build root dir.
    -G \"[Generator]\"(default=guess)
        CMake generator. Passing \"cmake -G\" for avail options. 
            \"Unix Makefiles\": As the first guess using GNU Make Utility on macOS/Linux/Cygwin/MSYS/Other UNIX-Like platform.
            \"Visual Studio XX\": As the first guess when building in a Visual Studio 20NN Developer CMD/Powershell prompt on Windows.
            \"NMAKE\": Visual Studio Program Maintainance Utility NMake.
            \"Ninja\": Focus on speed small buildsystem.
            etc. (Not common used generator or tag to deprecated.)
    -P [PATH]
        Let CMake run cmake files(*.cmake) in script mode.
    -D <CMAKE_CACHE_NAME>=<CMAKE_CACHE_VAL>
        CMake cache entry for create/overwrite CMake Cache. Listed CMake Cache entry (As Flags) in [Repo Avail options] below.

    [Repo Avail options]
    -DENABLE_DEBUG=[BOOL](default=NO)       Switch to DEBUG version Form build. [Deprecated(Experimental)]
    -DBUILD_FORM=[BOOL](default=ON)         Build sequential version form.
    -DBUILD_TFORM=[BOOL](default=OFF)       Build threaded version form.
    -DBUILD_PFORM=[BOOL](default=OFF)       Build MPI(Message Passing Interface) version form.
    -DWINAPI=[BOOL](default=guess)          Build with POSIX/Windows API. CMake guess from Operation System type.
    -DWITH_MODULES=[BOOL](default=NO)       Build a Environment Modules tcl shell script(cea-hpc EnvModules).
    -DWITH_ZLIB=[BOOL](default=NO)          Linking with ZLIB.
    -DWITH_ZSTD=[BOOL](default=NO)          Linking with Z Standard Compression Library(ZSTD).
    -DWITH_GMP=[BOOL](default=NO)           Linking with GNU Multiple Precision Arithmetic Library(GMP).
    -DWITH_MPFR=[BOOL](default=NO)          Linking with GNU Multiple Precision Floating-Point Reliable Library(MPFR).
        If zlib/zstd/gmp/mpfr is not in system paths like $INCLUDE and $LIB, pass \"-D CMAKE_PREFIX_PATH=<LIBRARY_INSTALL_PATH> \" cache with library install dir.

    -DSHARE_LIB=[BOOL](default=NO)  Linking with Shared/Static library.
        YES: Linking with Shared Object(*.so)/Dynamic Link Library(*.dll).
        NO:  Linking with Static library(*.a/*.o)/Object File Library(*.lib).

    -DEXPORT_PACKAGE=[BOOL](default=OFF)    Export a redistributable executable package.
            NSIS: Nullsoft Scriptable Install System. Only Avail on Windows.
            TXZ:  XZ compressed Tarball.
            TGZ:  GZip compressed Tarball.
            7Z:   7-Zip compress package.
            DEB:  Debian based Linux install package to dpkg/apt.
            RPM:  RHEL Based Linux install package to yum/dnf.
                etc.

    -DDEPMODE=[string]    Using a configuration of compile flags comes with the Autoconf.
        gcc3:               CMake loads a Flag set from Autoconf guess.

    -DMSVC_OPTIM=[string] Avail options on MSVC targeting x86/x64 processor systems.
        favor:              CMake identifies CPU type and vendor with MSVC specified CPU optimization.
        blend/generic:      CMake allows MSVC enables generic optimize for all x86/x64 CPUs.

    [General CMake Cache Entry]

    -DCMAKE_PREFIX_PATH=[PATH]              Path with CMake find package use. Use semicolon to seperate multi path string entry.
    -DCMAKE_INSTALL_PATH=[PATH]             Path of default install directory.
    -DCMAKE_C_COMPILER=[string]             C   language compiler.
    -DCMAKE_CXX_COMPILER=[string]           C++ language compiler.
    -DCMAKE_C_FLAGS=[string]                C   language compiler flags Prefix.
    -DCMAKE_CXX_FLAGS=[string]              C++ language compiler flags Prefix.
    -DCMAKE_EXE_LINKER_FLAGS=[string]       Linker Flags Prefix.
    -DCMAKE_BUILD_TYPE=[string]             CMake build type configuration. Pick one: \"Debug;Release;RelWithDebInfo;MinSizeRel\"

    [Autoconf script flags alias]

    -DINSTALL=[PATH]                        Alias => CMAKE_INSTALL_PREFIX
    -DCC=[string]                           Alias => CMAKE_C_COMPILER
    -DCXX=[string]                          Alias => CMAKE_CXX_COMPILER
    -DCFLAGS=[string]                       Alias => CMAKE_C_FLAGS
    -DCXXFLAGS=[string]                     Alias => CMAKE_CXX_FLAGS
    -DLDFLAGS=[string]                      Alias => CMAKE_EXE_LINKER_FLAGS

    CMake build command:
    \"cmake --build <DIR> --config <BUILD_TYPE> --target <TARGET>\"

    [Set options]

    --build [PATH]              CMAKE_BINARY_DIR where actually run build. Suggest same dir with -B<PATH>.
    --config [string]           Configures which CMake build type compiles.
    --target [string]           Build target defined in CMakeLists.txt.
                                In this repo, different build target(tform/pform) has been set to by flag control, so the target is form.
                                > Passing `install` to --target option run PHONY target to install.
                                > Passing `clean`   to --target option run PHONY target to clean files.

    [Avail Build info]

    - Compilers:
        gcc/g++:        GNU Compiler Collection(GCC) C/C++ language frontend with **GNU-Like** command line.
        clang/clang++:  LLVM Compiler Infastructure C/C++ language frontend with **GNU-Like** command line for targeting **UNIX-Like**.
        clang-cl:       LLVM Compiler Infastructure C/C++ language frontend with **MSVC-Like** command line for targeting **Windows**.
        cl:             Microsoft Optimized Visual C/C++ compiler driver a.k.a. MSVC.
        icl:            Intel Classic C/C++. This has been discontinued in 2023.X version by Intel move it to its LLVM Backend.
        icx:            Intel oneAPI DPC++/C++ Compiler driver with LLVM Backend(IntelLLVM).
        nvc/nvc++:      NVIDIA/PGI HPC SDK C/C++ language frontend. Enabled symlink pgcc/pgc++.

      Not supported C/C++ compiler:
        Open Watcom.    This is still not been tested.
        bcc64:          Enbracardo Borland 6.XX/7.XX C/C++ Compiler with LLVM Backend. still not been tested.
        tcc:            Tiny C compiler. This is only C languange frontend, no C++ compile.
        Other legacy targeted for 16/32-bit target compilers.


                    [========        CPack configuration        ========]
    Setup your build and wrap up to a redistributable Form compiler package.

    Command: \"cpack -G <CPACK_GENERATOR>\"
     - If not pass -G<CPACK_GENERATOR>: 
        CMake follows if you've gived `-D EXPORT_PACKAGE=<CPACK_GENERATOR>`. If you not config \"-DEXPORT_PACKAGE\" with cpack command instead, 
            just type \"cpack\" command and that's it.
        CMake uses your gived \"-G<CPACK_GENERATOR>\" on cpack command which cmake finds availiable cpack generator.
     - Local Machine avail CPack generator: Type command \"cpack -G\" to list.


                    [========        CTest configuration        ========]
    This CTest configuration only avails on a UNIX-Like environment, Using Ruby language and Test/Unit.

    The initial CTest configure is for all task. Activate this CTest functionality should be activate in the CMake configuration phase 
        with passing `-D`



                    [========         [License COPYING]         ========]

                          Copyright (C) 1984-2023 J.A.M. Vermaseren
            When using this file you are requested to refer to the publication
            J.A.M.Vermaseren \"New features of FORM\" math-ph/0010025
            This is considered a matter of courtesy as the development was paid
            for by FOM the Dutch physics granting agency and we would like to
            be able to track its scientific use to convince FOM of its value
            for the community.

            FORM is free software: you can redistribute it and/or modify it under the
            terms of the GNU General Public License as published by the Free Software
            Foundation, either version 3 of the License, or (at your option) any later
            version.

            FORM is distributed in the hope that it will be useful, but WITHOUT ANY
            WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
            FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
            details.

            You should have received a copy of the GNU General Public License along
            with FORM.  If not, see <http://www.gnu.org/licenses/>.

")
