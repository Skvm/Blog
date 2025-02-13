@echo off
setlocal

:: Set source and destination directories
set "SOURCE=E:\Obsidian Notes\Blog Posts"
set "DESTINATION=C:\Users\PC101\quartz\content"

:: Copy files from source to destination
echo Copying files from %SOURCE% to %DESTINATION%...
xcopy "%SOURCE%\*" "%DESTINATION%\" /s /i /y

if errorlevel 1 (
    echo Error copying files. Exiting...
    exit /b 1
) else (
    echo Files copied successfully.
)

:: Navigate to the destination directory
cd /d "%DESTINATION%"
if errorlevel 1 (
    echo Error changing directory to %DESTINATION%. Exiting...
    exit /b 1
)

:: Add all files to staging
echo Pushing files...
cd /d "C:\Users\PC101\quartz"
npx quartz sync --no-pull

echo All tasks completed successfully.
endlocal
exit /b 0