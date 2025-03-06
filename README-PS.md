
# About this P.S.

## About adding CMake(Cross Platform Make) buildsystem

This is a testing playground for FORM project, adding a little-bit Cross Platform Make(CMake) buildsystem support, originally forked by [tueda/form appveyor branch] and now is re-forked from [vermaseren/form]. Providing modern CMake for FORM project new develop extensionability.

This fork repo is from:
```
    # Original CMake source base id from: 
    #   vermaseren/form (latest)
    #               |
    #               ├──>  tueda/form (4.2) --branch=appveyor
    #               |               |
    #               |               |
    #               |               └─> taixeflar/form (4.2) ──────> X    
    #               |                        |
    #               |                        |   CMake Buildsystem source(CMakeLists.txt, CMake modules)
    #               |                        ↓
    #               └─────────────────> taixeflar/form
```

## Something disclaim and notice

- Something changes from the buildsystem: Like project builds name passing, moving source file to subdirs, changes definition etc is trying to make experimental changes and have new ways to re-define project itself, not meaning to destory or ruin it. 

- Verbose Buildstamp: This is what I want to make a different self-build Form compiler have each details, from build-date to build-type/compiler/cpu-archs/ etc. might have the diagnostic abilities for what build can have different properties on it. The [startup.c](sources/startup.c) has a new definition `CMAKE_VERBOSE_BUILDSTAMP` and it's activated to not corrupt the original Automake build uses. 

- Automake/Autoconf replacement: This is not the final target, even not considered before. FORM project is developed in very early date, developed on UNIX-Like environment, contains with POSIX properties; Automake/Autoconf is the original solution to ensure FORM has its original functionality and POSIX properties. CMake is the new support for can have direct build on Different based OS/processors, and with modern CMake 3.X build support.

- CMake build: 
  
  In now days seems the cross-build obsticles are OS difference(macOS/Linux/BSD vs Windows), not seem the processor problems(x86-64/AArch64/OpenPOWER/RISC-V etc.) yet(Maybe ?), so this cmake supported repo is the solution targeting for:
  - Targets on Windows platform with MinGW-w64 and CMake local install in a direct build favor.
  - First priority on different local machine build development with CMake.
  - Those who have strong intolerant and want to get rid off Cygwin/MSYS2 env share-libs/DLLs(I believe there's always have kind of user).
  - If you have strong favor on using MSVC to develop on full Windows support.
  - If you have strong favor on using other individual GCC/Clang compile with pure Windows env.

   Of course cmake is also availiable on macOS/Linux/BSD/Cygwin/MSYS2 and other UNIX-Like OS, so this repo in future will be a template  to ensure can add more UNIX/POSIX/Windows properties in it.

   And, yes, we(me) engaged issues on `--enable-float`. So we(me)'ll find out why in a later date. 

- Link Libraries: GMP, MPFR, ZLIB, ZSTD are passed build via VS2022, Cygwin, WSL2 Ubuntu. We(me) finished this.
- Float: We(me) still find out why and checking the original makefile(s) compile rules/flags etc. 

- [Listed compilers](#avail-build-info): The listed compilers is for if you don't know what compilers to use, or want have a compare to the autoconf [configure.ac](#./configure.ac). Actually there's lots of compiler id can find at cmake website [CMAKE_<LANG>_COMPILER_ID], so I list tested C/C++ compilers that actually can run for it. Also some compiler may can run but with some limitation, that's the part we(me) need to test.

 - Platform:
    |Platform|CPU Arch|Environment|Test Status|Compiler|Form|TForm|PForm|==Feature==|Float|Thread|MPI|GMP|MPFR|ZLIB|ZSTD|
    |:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
    |Windows|Intel 64|VS2022|Tested|MSVC v143|V|V|V|\|                                |X|Pthread4W|MSMPI|Strawberry c|Strawberry c|V|V|
    |Windows|Intel 64|VS2022|Tested|Clang 17.0.6|V|V|V|\|                             |X|Pthread4W|MSMPI|Strawberry c|Strawberry c|V|V|
    |Windows|Intel 64|oneAPI|Tested|icx 2024.1|V|V|V|\|                               |X|Pthread4W|MSMPI|Strawberry c|Strawberry c|V|V|
    |Windows|Intel 64|N/A|Tested|GCC 13.1.0|V|V|V|\|                               |X|Pthread4W|MSMPI|Strawberry c|Strawberry c|V|V|
    |Windows|Intel 64|Embarcadero|Tested|bcc64 7.X|X|
    |Windows|AMD64|VS2022|Not Tested|
    |Windows|ARM64|VS2022|Not Tested|
    |Windows|x86-64|WSL2 (Ubuntu)|Tested|GCC 11.4.0|V|V|V|\|                          |X|V|V|V|V|V|V|
    |Windows|x86-64|WSL2 (Ubuntu)|Tested|NVIDIA/PGI 27.0|V|V|V|\|                     |X|V|V|V|V|V|V|
    |Cygwin|x86-64|cygwin|Tested|GCC 11.5.0|V|V|V|\|                                  |X|V|V|V|V|V|V|
    |MSYS2|x86-64|UCRT64|Tested|GCC 14.1.0|V|V|V|\|                                   |X|V|V|V|V|V|V|
    |MSYS2|x86-64|MINGW64|Not Tested|
    |MSYS2|x86-64|MSYS|Not Tested|
    |MSYS2|x86-64|Clang64|Not Tested|
    |macOS|Intel 64|----|Not Tested|
    |macOS|ARM64|----|Not Tested|
    |Linux|Intel 64|Ubuntu 22.04|Not Tested|

    - Where the marked "V" or "X" means that FORM executable with the properties build success/failed. In the table, all shows that float option has failed with all platform/environment/toolchain build failed(source file `evaluate.c` and `float.c`), witch we compared with the Makefile by the original autoconf.

    - The CPU Arch is targeting for x86-64(Intel 64/AMD64), ARM64(Apple Silicon, Qualcomm Snapdragon, MediaTek Dimensity, NVIDIA Grace etc.) or anything else(if somewhere using PowerPC64 or RISC-V). ARM64 are no tested due to I have no avail devices.
    - The Embarcadero C++ builder C/C++ compiler is from Borland C/C++ compiler with LLVM backend. Now this compiler set is unable for CMake to test compile.
    - Where the tested `Windows Intel64` and `WSL2(Ubuntu)` is my Gaming/Daily use NB `ROG Zephyrus S15(2020)`.

## Ideas on cmake build features and anything else

1. Verbose buildstamp: from Git tags(if cmake merged to repo in future), `form3.h` and Top-Level `CMakeLists.txt`.

   This is quite major change for the FORM compiler's version extract and its definition. We(me) sync both autoconf and cmake with having the same version build detail defines.

   We(me) change on the version control with a verbose buildstamp(That means we(me) have modify on `startup.c` & `form3.h`):
    - From `autoreconf -iv` command gives `FORM Major.Minor (BUILD_DATE)` ==> `Form 4.3 (Date)`
    - To `cmake` configure gives: `FORM Major.Minor.Patch<BETA_TAG> [BUILD_TYPE, COMPILER](BUILD_TYPE, BUILD_DATE)`
      ```
       Form 5.0.0-beta1 [Debug, MSVC-v143 Build](Win11 Intel64, DATE)
       Form 5.0.0-beta1 [Release, GCC-13.1.0 Build](Cygwin x86_64, DATE)
       Form 5.0.0-beta1 [MinSizeRel, Clang-18.1.0 Build](Ubuntu 22.04 AMD64, DATE)
      ```
   We(me) refered the LLVM-Project's version control(What LLVM defines version number in the Top-Level `CMakeLists.txt`). So we(me) keep `form3.h`'s version control and add this feature to CMakeLists.txt, make it as 2 step version extract control. If this repo's been pulled, we(me) may add to 3-step version control(from git-tag/>> form3.h/>> CMakeLists.txt).
  
   Also we have changed build control:
      - Sequential version Form:   form  --> form
      - Threaded version Form:     tform --> tform
      - MPI version Form:        parform --> pform (We(me) add a symlink parform to install that always pform was build.)


2. Build Optional Console and some Automake/Autoconf configure.sh style-like flags make into CMake Cache Entry.

   In the initial design, we(me) refered LLVM-Project design(`-DLLVM_ENABLE_PROJECTS=clang;lld;lldb;.....`), but we(me) dropped this(the killed fork) and redesigned by passing each(reverse back to each flags like `--enable-threaded`, `--enable-float` etc.).

   We(me) changed to design a similar short flags entry(CMake called it as CMake Cache) and also Autoconf params as alias for CMake Cache entry:
   - `--enable-parallel` to `BUILD_PFORM`
   - `--enable-threaded` to `BUILD_TFORM`
   - `--enable-float` to `WITH_FLOAT`
   - `--prefix` to `INSTALL`
   - `CC/CXX/CFLAGS/CXXFLAGS`

3. Change definition's Flag insert.

    Here let me explain. Where there was `-DDEBUGGING` definition been used in the Autoconf `VORM` defined flag and add to `CMAKE_C_FLAGS` and `CMAKE_CXX_FLAGS` in the initial CMake design. 
    
    Now I moved these from modifying `CMAKE_C_FLAGS` and `CMAKE_CXX_FLAGS` to another way:
    - `add_definitions()`: Where definition flags in a global effect, like `-DDEBUGGING`, `-DNDEBUG`, `-DHAVE_CONFIG_H` and `-DCMAKE_VERBOSE_BUILDSTAMP`.
    - `target_compile_definitions()`: Specified target with only need specified flags like `-DWITHPTHREAD` for `tform`, `-DWITHMPI` `-D-DPF_WITHGETENV` `-DPF_WITHLOG` for `pform` etc.
    
    Be sure these are C/C++ compile definition flags, not CMake Cache entry. 

4. Add CPack support. This is for any possiable FORM authors/collaborators to make a redistributable installer for public release. The CPack will invoke package manager and with properties defined in CMake settings, export out the details(Install Directory, Install files, Documents, even write on Registry).

5. Add CTest initial support. This function now is only avail on Unix(Apple/Cygwin/Linux/WSL2 etc.), running the test script `check.rb` with Ruby Test/Unit. 

6. Help messages feature. Always needs some manual with your preped coding coffee, right?

   I've made a terminal print cmake help usage in `cmake/help.cmake`. In this repo, run the `help` shell script/batch script:
   ```
    ./help.sh
   ```
   ```
    .\help.bat
   ```
   If you needed is general cmake command line options:
   ```
    cmake -h,-H,--help,-help,-usage,/?       # CMake command help print
   ```



## Build preprocess
Before you do Form build on cmake, you should have these develop compoments:
 - CMake. Crossmake(CMake) buildsystem `cmake`. 
 - Compiler: You need a availiable C/C++ compiler for compiling Form project.
 - Library/Runtime: If Compiler or project needed 3rd Party C/C++ libraries.
     ```
      GMP
      MPFR
      PThreads
      MPI
      ZLIB
      ZSTD
     ```
 - Generator: Generating config/rules or any build makefile utility.
      On Linux: Install develop tools via package manager(by Linux distro or homebrew `brew`).
      ```
      sudo apt/dnf/yum/brew install gcc g++ make cmake ninja-build      # via apt/dnf/yum/brew package manager, on Linux Distro
      sudo pacman -S gcc g++ make cmake ninja-build                     # via Arch Linux/MSYS package manager
      
      sudo <PACKAGE_MANAGER> install libgmp-dev libmpfr-dev ...         # Developer Libraries.
      ```
      On macOS: You need Xcode installed and/or homebrew `brew`(for 3rd party software).
      ```
      xcode-select --install
      brew install ....
      ```
      On CYGWIN: You need run Cygwin Installer(GUI) `setup-x86_64.exe` and select listed tools to install. 
      
      Strongly not recommend using shell script `apt-cyg` to install(`apt-cyg` won't get package dependices. See [Issue #455](https://github.com/vermaseren/form/issues/455))
      ```
       bash
       gcc
       g++
       GNU Make
       cmake
       ninja-build
      ```
      - Go to [Cygwin Website] and download the installer: [setup-x86_64.exe]

      On MSYS/MSYS2: Install develop tools via package manager `pacman`.
      ```
      pacman -Syu
      pacman -S gcc g++ make cmake ninja-build                          # via pacman, on Arch Linux or MSYS2
      ```
      - Go to [MSYS2 Website] and get its installer.
  
      On Windows: You can manually select developer kit or use Visual Studio.
      ```
       CMake
       MinGW-W64 / Strawberry Perl(Comes with a MinGW-w64 C/C++ compiler and library) / Code::Blocks / Dev C++
      ```
      - Kitware(CMake official developer) has released installer here: [Download CMake]
      - Download GCC tool chain: [Download MinGW-w64] or [Download Strawberry] or [Download DEV-C++] or [Download CodeBlocks] 
      ```
       Visual Studio
            MSVC v143/v142/v141/v140
            Windows 10/11 SDK
            CMake for Windows
      ```
      - Select Visual Studio 2022(Community version is enough): [Download VS2022]
     
     You should noticed that we have not talk about `tform` and `pform` support on Windows platform yet. So:

     - `tform`: We follows the pthreads desing on UNIX-like env, so we need have pthread library for Win32 like **fwbuilder/pthreads4w** or **GerHobbelt/pthread-win32** library for linking to `tform`. Passing the library's install path with `-DCMAKE_PREFIX_PATH`.
     - `pform`: In Linux/macOS/X-BSD, you can compile `parform` with Message Passing Interface(MPI) library like **pmodel/mpich** or **open-mpi/ompi**. However on Windows platform, where MPI SDKs/runtimes is supported by Microsoft(MSMPI). So we need download from Official Microsoft website with `msmpisetup.exe` and `msmpisdk.msi`(You can install them in a same directory).
      
## Build
Run `help.sh`/`help.bat` or `cmake -P cmake/help.cmake` for futher details.

Here give my build example. 

Specified build without float support, static linking with GMP, MPFR, ZLIB, ZSTD, with building all(`form`+`tform`+`pform`), and with pre-built libraries installed in these directories:
- GMP: Installed with Strawberry Perl's C library: `C:/Developer/Strawberry/c`
- MPFR: Installed with Strawberry Perl's C library: `C:/Developer/Strawberry/c`
- ZLIB: Local CMake build and installed in: `C:/Developer/lib/zlib`
- ZSTD: Local CMake build and installed in: `C:/Developer/lib/zstd`
- MPI SDK: Installation with msmpisdk.msi in: `C:/Developer/MSMPI`
- MPI EXEC: Installation with msmpiexec.exe in: `C:/Developer/MSMPI`
- Form build Install Directory in: `C:/Developer/Form/5.0.0-beta1`

1. Clone this repo. You can do it a shallow clone if you want just build and in use.
```
 git clone https://github.com/TaiXeflar/form.git --depth=1
```
2. Enter repo and build out of source.
```
 cd form
 mkdir build; cd build
```
3. Build with the project configure tools like GNU/Autotools or CMake.
```
 cmake .. -G Ninja \
    -DCMAKE_INSTALL_PREFIX="C:/Developer/Form/5.0.0-beta1" \
    -DCMAKE_PREFIX_PATH="C:/Developer/lib/zlib;C:/Developer/lib/zstd;C:/Developer/MSMPI;C:/Developer/Strawberry/c"
    -DBUILD_SHARED_


```
4. Run your selected generator.

## Future ideas

The future ideas/todo list:

- ~~Library dependices.~~(Finished GMP/MPFR/ZLIB/ZSTD Linking)
- ~~POSIX Thread `tform` and MPI `pform`(parform)~~
- Floating point `WITH_FLOAT` option, with stricted rules to build.
- Debug version "VORM" series RE-Definition. Maybe will in a multi-build configuration `cmake -G "Ninja Multiconfig"/"Visual Studio"`.
- Some POSIX options
- ~~CUDA Form `cuform` (Maybe Next year 4/1)~~
- Anything else

## Debug report
Though Symbolic Form project's buildsystem is managed by Automake/Autoconf, using CMake as buildsystem is still new for try.
Report CMake build system bugs/questions at FORM issues reply.
Do not open issues at the original one(vermaseren/form)! The original repo has no CMake support.

## Avail build info

Supported Compiler list. Hint: `<CMAKE_C_COMPILER>`/`<CMAKE_CXX_COMPILER>`
- GCC: GNU Compiler Collection(GCC) C/C++ compiler driver `gcc`/`g++` with **GNU-Like** command line and with GNU Linker `ld`.
- LLVM/CLang: LLVM Compiler Infastructure C/C++ language frontend clang compiler. 
    - By `clang`/`clang++` with **GNU-Like** command line for targeting **UNIX-Like**.
    - By`clang-cl`/`clang-cl` with **MSVC-Like** command line for targeting **Windows**. 
    - CMake defines Linker is `lld`(by **GNU-Like** is `ld.lld` or by **MSVC-Like** is `lld-link.exe`). If `lld` not exists, CMake will set GNU linker `ld`(by **GNU-Like**) or MSVC linker `link.exe`(by **MSVC-Like**).
- MSVC: Microsoft Optimized Visual C/C++ compiler driver, a.k.a. MSVC. with MS incremental linker `link.exe`.
- Intel oneAPI: Intel oneAPI(or Legacy Intel Parallel Studio XE) DPC++/C++ and Intel Classic C/C++ Compiler. Intel has discontinued and deprecated Intel Classic C/C++ `icc` in 2024.0 version Intel oneAPI, moving C/C++ compiler to Data Parallel C++ (DPC++) version with LLVM Backend. Strongly recommends Install Intel oneAPI DPC++/C++ with a pre Install comes with Microsoft Visual Studio(If on Windows x64 Platform); on Linux you should have GCC compilers(Binutils/GCC etc.) installed.  
    - By `icx`/`icpx` for **GNU-Like**.
    - By `icx-cl`/`icx-cl` for **MSVC-Like**.
    - CMake(on Windows) invokes MS Incremental Linker `link.exe` as first selected linker, then Intel's linker `xlink.exe`.
- NVIDIA/PGI: NVIDIA HPC SDK. The existing legacy PGI compilers has rebranded into NVIDIA HPC SDK(Start in 20.7 version), based on LLVM Backend. Note that over 20.7 NV HPC SDK only avail on Linux(support AMD64/ARM64/PowerPC64).
    - By legacy callout is `pgcc`/`pgc++`. These compiler executable before 20.4 is the actual PGI compiler.
    - By NVIDIA C/C++ is `nvc`/`nvc++`, with symlimk as `pgcc`/`pgc++`(After SDK 20.7).
    - Note that `nvcc` is NVIDIA CUDA compiler, not a C/C++ compiler.

These are not supported C/C++ compiler:
 - Open Watcom. I'm still not ready for doing this test.
 - Borland C/C++ 5.5 compiler `bcc32`.
 - Embarcadero Borland 6/7 C/C++ compiler `bcc64` with LLVM Backend.
 - TinyCC `tcc`. This is only C languange frontend, no C++ compile.
 - Orange C compiler.
 - Other legacy targeted for 16/32-bit target compilers.



[tueda/form appveyor branch]:https://github.com/tueda/form/tree/appveyor
[vermaseren/form]:https://github.com/vermaseren/form

[Cygwin Website]: https://www.cygwin.com/
[setup-x86_64.exe]: https://www.cygwin.com/setup-x86_64.exe
[MSYS2 Website]: https://www.msys2.org/#installation
[Download CMake]: https://cmake.org/download/
[Download MinGW-w64]: https://www.mingw-w64.org/downloads/
[Download Strawberry]: https://strawberryperl.com/releases.html
[Download DEV-C++]: https://www.bloodshed.net/
[Download CodeBlocks]: https://www.codeblocks.org/downloads/binaries/
[Download VS2022]: https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&channel=Release&version=VS2022&source=VSLandingPage&cid=2030&passive=false
[CMAKE_<LANG>_COMPILER_ID]:https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html