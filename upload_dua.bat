@echo off
setlocal enabledelayedexpansion

:: ==========================================
::        MASTER CONFIGURATION (FIXED)
:: ==========================================
:: Bhai, yahan tera link maine fix kar diya hai
set "REPO_URL=https://github.com/astrosyedsahab-website/Website-Tools-Assets.git"

:: Ye line apne aap folder ka naam nikal legi
for %%I in ("%cd%") do set "CURRENT_FOLDER=%%~nxI"

:menu
cls
echo ==========================================
echo    GITHUB ASSETS MASTER MANAGER (PRO)
echo ==========================================
echo  Current Folder: %CURRENT_FOLDER%
echo  Repo: Website-Tools-Assets
echo ------------------------------------------
echo  1. Upload File to Release (PDF/Video)
echo  2. Create New Release Tag (Github Web)
echo  3. Upload Single File to Repo Code
echo  4. UPLOAD ENTIRE FOLDER TO REPO (Pro Mode)
echo  5. Exit
echo ------------------------------------------
set /p choice="Bhai, option select karo (1-5): "

if "%choice%"=="1" goto release_upload
if "%choice%"=="2" goto create_tag
if "%choice%"=="3" goto repo_file
if "%choice%"=="4" goto folder_push
if "%choice%"=="5" exit
goto menu

:folder_push
cls
echo [STEP 4] UPLOADING ENTIRE FOLDER TO GITHUB...
echo ------------------------------------------
:: Git Setup
git init
:: Purana remote hata kar naya fresh link lagana
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

:: Sync with GitHub
echo Checking connection...
git fetch origin main >nul 2>&1
git checkout main >nul 2>&1 || git checkout -b main

:: Uploading Data
git add .
set /p commit_msg="Folder ka description likho (e.g. Added Dua Tool): "
git commit -m "%commit_msg%"
echo Bhai, data bhej raha hoon, thoda sabar rakho...
git push origin main

echo ------------------------------------------
echo MUBARAK HO! POORA FOLDER UPLOAD HO GAYA!
pause
goto menu

:release_upload
cls
echo [STEP 1] UPLOAD TO RELEASE
set /p file_name="File ka poora naam dalo (with extension): "
set /p tag_name="Release Tag ka naam dalo (e.g. dua-wazifa-tool): "
gh release upload %tag_name% "%file_name%" --clobber
pause
goto menu

:create_tag
cls
echo [STEP 2] CREATE NEW RELEASE TAG
set /p tag_name="Naya Tag Name dalo (e.g. namaz-v1): "
set /p tag_desc="Release ka description dalo: "
gh release create %tag_name% --title "%tag_name%" --notes "%tag_desc%"
pause
goto menu

:repo_file
cls
echo [STEP 3] UPLOAD SINGLE FILE TO CODE
set /p file_name="File ka naam dalo: "
git add "%file_name%"
git commit -m "Updated %file_name%"
git push origin main
pause
goto menu