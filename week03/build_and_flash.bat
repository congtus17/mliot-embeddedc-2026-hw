@echo off

echo STEP 1: CLEANING BUILD DIRECTORY

if exist build (
    echo Deleting existing build folder...
    rmdir /s /q build
)

echo.
echo STEP 2: CONFIGURING PROJECT WITH CMAKE

cmake -B build -G Ninja

if %ERRORLEVEL% neq 0 (
    echo Configure failed!
    pause
    exit /b 1
)

echo.
echo STEP 3: COMPILING FIRMWARE WITH NINJA

cmake --build build

if %ERRORLEVEL% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo STEP 4: FLASHING FIRMWARE TO TARGET MCU

STM32_Programmer_CLI -c port=SWD ^
-w build/app_firmware.bin 0x08000000 ^
-v ^
-rst

if %ERRORLEVEL% neq 0 (
    echo Flash failed!
    pause
    exit /b 1
)

echo.
echo ============================
echo BUILD AND FLASH SUCCESSFUL!
echo ============================

pause