@echo off
setlocal enabledelayedexpansion
title ASTRO SYED SAHAB - PROJECT MANAGER PRO

:: --- AUTO-REPO DETECTOR ---
for %%I in ("%cd%") do set "CURRENT_REPO=%%~nxI"
set "USERNAME=astrosyedsahab-website"
set "REPO_URL=https://github.com/%USERNAME%/%CURRENT_REPO%.git"

:: --- AUTO-CONNECT (Naye Repo ke liye) ---
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    color 0E
    echo [SYSTEM] Naya Project Detected: %CURRENT_REPO%
    git init
    git remote add origin !REPO_URL!
    git branch -M main
    echo [SYSTEM] Connected! ✅
    timeout /t 2 >nul
)

:menu
cls
color 0B
echo ==========================================================
echo           ASTRO SYED SAHAB - TERMINAL CONTROL
echo ==========================================================
echo  [SYSTEM] WORKING IN REPO: %CURRENT_REPO%
echo ----------------------------------------------------------
echo  [1] UPLOAD NEW FILES     (Nayi files bhejo)
echo  [2] REPLACE FILES        (Purani badlo)
echo  [3] UPLOAD ENTIRE FOLDER (Sab kuch ek saath)
echo  [4] REFRESH EVERYTHING   (Force Push/Clean)
echo  [5] DELETE FROM GITHUB   (Smart Clean)
echo  [6] EXIT                 (Bahar jao)
echo ----------------------------------------------------------
set /p choice="Bhai, kya karna hai? (1-6): "

if "%choice%"=="1" set "mode=UPLOAD" & goto destination_picker
if "%choice%"=="2" set "mode=REPLACE" & goto destination_picker
if "%choice%"=="3" goto fold_up
if "%choice%"=="4" goto fold_rep
if "%choice%"=="5" goto folder_select_del
if "%choice%"=="6" exit
goto menu

:destination_picker
cls
color 0E
echo ----------------------------------------------------------
echo  [%mode% MODE] KAHAN KAAM KARNA HAI?
echo ----------------------------------------------------------
echo  1. REPO CODE (Folders ke andar)
echo  2. GITHUB RELEASE (Badi files/Versions)
echo ----------------------------------------------------------
set /p dest="Option dalo (1-2): "

if "%dest%"=="1" goto folder_select
if "%dest%"=="2" goto release_logic
goto destination_picker

:folder_select
cls
color 0F
echo ----------------------------------------------------------
echo  [%mode% IN REPO] KAUNSE FOLDER MEIN JANA HAI?
echo ----------------------------------------------------------
set j=0
echo  0. [MAIN DIRECTORY]
for /d %%D in (*) do (
    set /a j+=1
    set "dir!j!=%%D"
    echo  !j!. %%D
)
echo ----------------------------------------------------------
set /p d_choice="Folder number dalo: "
if "%d_choice%"=="0" ( set "target_dir=." ) else ( set "target_dir=!dir%d_choice%!" )

:: --- README CHECKER LOGIC ---
if not "!target_dir!"=="." (
    if not exist "!target_dir!\README.md" (
        color 0C
        echo.
        echo [!] WARNING: README.md nahi mili !target_dir! mein.
        set /p create_md="Bhai, kya README file bana doon? (Y/N): "
        if /i "!create_md!"=="Y" (
            echo # !target_dir! - Assets Folder > "!target_dir!\README.md"
            echo This folder contains assets for !target_dir! >> "!target_dir!\README.md"
            git add "!target_dir!\README.md"
            echo [SUCCESS] README ban gayi! ✅
        )
    )
)

cls
color 0F
echo ----------------------------------------------------------
echo  [%mode% IN !target_dir!] PC KI FILES LIST:
echo ----------------------------------------------------------
set i=0
for /f "delims=" %%F in ('dir /b "!target_dir!"') do (
    if not "%%F"=="%~nx0" (
        set /a i+=1
        set "file!i!=%%F"
        echo  !i!. %%F
    )
)
echo ----------------------------------------------------------
set /p f_nums="Numbers dalo (Ex: 1 3): "

for %%n in (%f_nums%) do (
    set "fname=!file%%n!"
    if "!target_dir!"=="." ( git add "!fname!" ) else ( git add "!target_dir!/!fname!" )
)

set /p m="Description dalo: "
git commit -m "!mode!: Updated !target_dir! (%m%)"
git push origin main
goto success_msg

:release_logic
cls
color 0D
echo ----------------------------------------------------------
echo  [%mode% IN RELEASE] GITHUB PAR YE RELEASES HAIN:
echo ----------------------------------------------------------
gh release list
echo ----------------------------------------------------------
set /p tag="Tag Name dalo (Type Name): "

cls
echo ----------------------------------------------------------
echo  [%mode% IN RELEASE: %tag%] PC KI FILES:
echo ----------------------------------------------------------
set k=0
for /f "delims=" %%F in ('dir /b') do (
    set /a k+=1
    set "rfile!k!=%%F"
    echo  !k!. %%F
)
echo ----------------------------------------------------------
set /p r_num="File number dalo: "
set "r_target=!rfile%r_num%!"

if "%mode%"=="REPLACE" (
    gh release upload %tag% "!r_target!" --clobber
) else (
    gh release upload %tag% "!r_target!"
)
goto success_msg

:folder_select_del
cls
color 0C
echo ----------------------------------------------------------
echo  [DELETE] KAUNSE FOLDER SE SAFAI KARNI HAI?
echo ----------------------------------------------------------
set j=0
echo 0. [MAIN FOLDER]
for /d %%D in (*) do ( set /a j+=1 & set "dir!j!=%%D" & echo !j!. %%D )
set /p d_choice="Folder number: "
if "%d_choice%"=="0" ( set "target_dir=." ) else ( set "target_dir=!dir%d_choice%!" )

cls
echo  [DELETE MODE] !target_dir! PC FILES:
set i=0
for /f "delims=" %%F in ('dir /b "!target_dir!"') do ( set /a i+=1 & set "dfile!i!=%%F" & echo !i!. %%F )
set /p d_num="Number dalo: "
set "d_target=!dfile%d_num%!"
if "!target_dir!"=="." ( set "final_path=!d_target!" ) else ( set "final_path=!target_dir!/!d_target!" )

echo ----------------------------------------------------------
echo  1. Sirf GitHub se hatao  |  2. Dono jagah se
echo ----------------------------------------------------------
set /p d_type="Choice: "
if "%d_type%"=="1" ( git rm -r --cached "!final_path!" ) else ( git rm -r "!final_path!" )
git commit -m "Removed !final_path!"
git push origin main
goto success_msg

:fold_up
cls
color 0A
echo  [FULL UPLOAD] SAB KUCH BHEJ RAHA HOON...
git add .
set /p m2="Description: "
git commit -m "Full Upload: %m2%"
git push origin main
goto success_msg

:fold_rep
cls
color 0E
echo  [FORCE REFRESH] GITHUB KO PC JAISA BANA RAHA HOON...
git add .
set /p m3="Message: "
git commit -m "Force Refresh: %m3%"
git push origin main --force
goto success_msg

:success_msg
color 0A
echo.
echo ----------------------------------------------------------
echo     BHAI, KAAM HO GAYA! [SUCCESS] 
echo ----------------------------------------------------------
echo.
echo [MENU PAR WAPAS JANE KE LIYE KOI BHI KEY DABAYE]
pause >nul
goto menu