@echo off
setlocal enabledelayedexpansion

:: --- AUTO-REPO & SUB-FOLDER DETECTOR ---
:: Ye line "Baap Folder" (Repo) ka naam uthayegi
for %%I in ("%cd%\..") do set "REPO_NAME=%%~nxI"
:: Ye line tere "Current Folder" (Sub-folder) ka naam uthayegi
for %%I in ("%cd%") do set "SUB_NAME=%%~nxI"

set "USERNAME=astrosyedsahab-website"
set "REPO_URL=https://github.com/%USERNAME%/%REPO_NAME%.git"

:menu
cls
echo ==========================================
echo     ASTRO SYED SAHAB - ULTIMATE MANAGER
echo ==========================================
echo   WORKING IN REPO: %REPO_NAME% (%SUB_NAME%)
echo ------------------------------------------
echo   1. UPLOAD FILE IN RELEASE (Nayi PDF/Video)
echo   2. REPLACE FILE IN RELEASE (Purani Hatakar Nayi)
echo   3. UPLOAD SINGLE IMAGE (Nayi Image Repo mein)
echo   4. REPLACE IMAGE IN REPO CODE (Update Image)
echo   5. UPLOAD ENTIRE FOLDER (Saara Samaan Naya)
echo   6. REPLACE/REFRESH ENTIRE FOLDER (Full Update)
echo   7. Exit
echo ------------------------------------------
set /p choice="Bhai, kya karna hai? (1-7): "

if "%choice%"=="1" goto rel_up
if "%choice%"=="2" goto rel_rep
if "%choice%"=="3" goto img_up
if "%choice%"=="4" goto img_rep
if "%choice%"=="5" goto fold_up
if "%choice%"=="6" goto fold_rep
if "%choice%"=="7" exit
goto menu

:: ... baaki saara code (rel_up, img_up, etc.) bilkul same rahega ...
:: (Wahi copy-paste kar lena jo pehle diya tha)