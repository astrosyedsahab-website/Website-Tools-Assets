@echo off
setlocal enabledelayedexpansion

:: --- AUTO-REPO & SUB-FOLDER DETECTOR ---
for %%I in ("%cd%\..") do set "REPO_NAME=%%~nxI"
for %%I in ("%cd%") do set "SUB_NAME=%%~nxI"
set "USERNAME=astrosyedsahab-website"
set "REPO_URL=https://github.com/%USERNAME%/%REPO_NAME%.git"

:menu
cls
echo ==========================================
echo    ASTRO SYED SAHAB - FILE PICKER PRO
echo ==========================================
echo  WORKING IN: %REPO_NAME% (%SUB_NAME%)
echo ------------------------------------------
echo  1. UPLOAD FILE IN RELEASE
echo  2. REPLACE FILE IN RELEASE
echo  3. UPLOAD SPECIFIC IMAGES/FILES 
echo  4. REPLACE SPECIFIC IMAGES/FILES
echo  5. UPLOAD ENTIRE FOLDER 
echo  6. REFRESH EVERYTHING 
echo  7. Exit
echo ------------------------------------------
set /p choice="Bhai, kya karna hai? (1-7): "

if "%choice%"=="1" goto rel_up
if "%choice%"=="2" goto rel_rep
if "%choice%"=="3" goto file_select
if "%choice%"=="4" goto file_select
if "%choice%"=="5" goto file_select
if "%choice%"=="6" goto fold_rep
if "%choice%"=="7" exit
goto menu

:file_select
cls
echo [SELECTION] IS FOLDER MEIN YE FILES HAIN:
echo ------------------------------------------
set i=0
for /f "delims=" %%F in ('dir /b') do (
    if not "%%F"=="%~nx0" (
        set /a i+=1
        set "file!i!=%%F"
        echo !i!. %%F
    )
)
echo ------------------------------------------
echo Bhai, jo jo bhejna hai unke number dalo (Example: 1 3 5)
set /p f_nums="Numbers dalo: "

for %%n in (%f_nums%) do (
    set "target=!file%%n!"
    if not "!target!"=="" (
        echo Adding: !target!
        git add "!target!"
    )
)

set /p m="Description dalo: "
git commit -m "Updated specific files: %m%"
git push origin main
pause
goto menu

:rel_up
cls
echo [RELEASE] KAUNSI FILE RELEASE MEIN DALNI HAI?
echo ------------------------------------------
set i=0
for %%F in (*.pdf *.zip *.mp4 *.webp *.jpg *.png) do (
    set /a i+=1
    set "rfile!i!=%%F"
    echo !i!. %%F
)
echo ------------------------------------------
set /p r_num="File number dalo: "
set "r_target=!rfile%r_num%!"
set /p t1="Tag Name dalo: "
gh release upload %t1% "!r_target!"
pause
goto menu

:rel_rep
cls
echo [RELEASE REPLACE] KAUNSI FILE REPLACE KARNI HAI?
echo ------------------------------------------
set i=0
for %%F in (*.pdf *.zip *.mp4 *.webp *.jpg *.png) do (
    set /a i+=1
    set "rfile!i!=%%F"
    echo !i!. %%F
)
echo ------------------------------------------
set /p r_num="File number dalo: "
set "r_target=!rfile%r_num%!"
set /p t2="Tag Name dalo: "
gh release upload %t2% "!r_target!" --clobber
pause
goto menu

:fold_rep
cls
echo [FULL REFRESH] POORA DATA BHEJ RAHA HOON...
pushd ..
git add .
set /p m2="Description: "
git commit -m "Full Refresh: %m2%"
git push origin main --force
popd
pause
goto menu