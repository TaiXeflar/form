
# About this P.S.

In order to get closer to the orignal `vermaseren/form` repo, I changed the source fork to the root one:

This fork repo is from:
```
    # Original CMake source base id from: 
    #   vermaseren/form 
    #               ├──>  tueda/form (4.2) --branch=appveyor
    #               |               |
    #               |               └─> taixeflar/form (4.2) ──────> X    
    #               |                        |
    #               |                        |   CMake Buildsystem source(CMakeLists.txt)
    #               |                        ↓
    #               └─────────────────> taixeflar/form
```

## About adding buildsystem to Crossmake

This is a testing playground for FORM project to build on cross-platform, originally forked by [tueda/form](https://github.com/tueda/form) appveyor branch and now is re-forked from [vermaseren/form](https://github.com/vermaseren/form). 

FORM(Symbolic Form) is developed on UNIX-Like system, both Linux and macOS have source code and release pre-built binaries. FORM is build by GNU make utility: GNU/Make, automake, autoconf, m4 language etc. making Form can have POSIX standard properties. 

If you are Windows user want have FORM "with POSIX", you can use Cygwin/MSYS2/MinGW, or running WSL2 to build Form compiler by source.

## Ideas on cmake build features and anything else

1. Changed version configuration from `form3.h` to top-level `CMakeLists.txt`.

   This is quite major change for the FORM compiler's version extract and its definition. 

2. Build Optional Console witth CMake Cache.

   In the original design, we(me) refered LLVM-Project design, but we dropped this and redesigned by passing each.

   Mension for the boolean can have same effect words:
   ```
   TRUE --> YES / ON
   FALSE --> NO / OFF
   ```

   The cmake configuration command is:
   ```
    cmake -S <CMAKE_SOURCE_DIR> -B <CMAKE_BINARY_DIR> -G <CMAKE_GENERATOR> -D <CMAKE_CACHE_FORCE>.........
   ```
   Passing CMake cache by command `cmake -D<YOUR_FORCED_CMAKECACHE>=<CMAKECACHE_VALUE>` to pass avail options, comes with these legal value is `YES/ON/TRUE` or `NO/OFF/FALSE`:
   - `BUILD_FORM`: Build `form` option for form. Default is TRUE.
   - `BUILD_TFORM`: Build `tform` option for thread version form. Default is OFF.
   - `BUILD_PFORM`: Build `pform` option for parallel version form. Default is OFF.
   - `WITH_FLOAT`: Enable float support when building form with GMP library dependices. Default is OFF.
   - `WITH_MODULES`: Enable CMake build a Environment Modulefiles(tcl shell language script). Default is OFF.
   - `EXPORT_LOG`: Print `BuildInfo.txt` as cmake build record details in default. Default is OFF.
   - `EXPORT_XZTARBALL`: Package the build to a redistributable compressed xz tarball.

   Common cmake cache: CMake will have it's guess from system and environment, forcing change settings by passing string.
   - `CMAKE_C_COMPILER`: Select C language frontend. Probably `gcc`/`clang`/`clang-cl.exe`/`cl.exe`.
   - `CMAKE_CXX_COMPILER`: Select CXX language frontend. Probably `g++`/`clang++`/`clang-cl.exe`/`cl.exe`.
   - `CMAKE_INSTALL_PREFIX`: This is for the build installation directory. If this cache not defined, CMake will install to `/usr/local/bin` or `C:/Program Files (x86)` and requires elevation.
   - `CMAKE_PREFIX_PATH`: Cache for manually add PATHs for CMAKE to search for dependices/libraries. This flag will be off until need find GMP library or any 3rd party library else.
   - `CMAKE_BUILD_TYPE`: In general CMake have `Debug`/`Release`/`RelWithDebInfo`/`MinSizeRel`, with only one version can build. Instead of build VORM, if you want to build with debug options(flags etc.) can passing `Debug` or `RelWithDebInfo` build. If you need stable use, passing `Release`, or `MinSizeRel` of you have limited disk space.
   - option `-G`: Passing to CMake Generator. General on UNIX-Like uses GNU Make utility, so passing `"Unix Makefiles"`; on Windows Visual Studio solution passing "Visual Studio XX"(`XX` depends on your VS version. Also only Visual Solution enables multiple build type like `-DCMAKE_BUILD_TYPE="Debug;MinSizeRel;..."`). If you need fastest build by passing `Ninja` for ninja generator.
   - option `-S`: Project Source code location(Where contains the top-level CMakeLists.txt). This can omitted which cmake will find the first path string passed in the command line as the source root.
   - options `-B`: Where to build project. This also omitted which cmake will find the second path string passed in the command line as the build directory.

## Future ideas

The future ideas/todo list:

- `EXPORT_INSTALLER`: Package the build to a same/similar OS/CPU-Arch redistributable installer. By Linux OS is package manager(`*.deb`/`*.rpm`), By MacOS is `*.pkg`, By Windows using cpack command with NSIS(Nullsoft Scriptable Install System) to `*.exe` installer. This option is not designed yet, but can help build Linux distro package/macOS package or Windows Installer.
- Some POSIX options
- Anything else

