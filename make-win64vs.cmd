@echo off
setlocal
path=%ProgramFiles%\CMake\bin;%ProgramFiles%\NASM;%path%
if not exist build\win64vs mkdir build\win64vs
pushd build\win64vs
cmake -G"Visual Studio 15 2017 Win64" ^
    -DCMAKE_INSTALL_PREFIX=install ^
    -DLeptonica_DIR=..\leptonica\build\win64vs\install\cmake ^
    -DLeptonica_LIBRARY_DIRS=..\leptonica\build\win64vs\install\lib ^
    -DLeptonica_INCLUDE_DIRS=..\leptonica\build\win64vs\install\include\leptonica ^
    -DBUILD_TRAINING_TOOLS=OFF ^
    -DBUILD_TESTS=OFF ^
    %~dp0
popd
endlocal

