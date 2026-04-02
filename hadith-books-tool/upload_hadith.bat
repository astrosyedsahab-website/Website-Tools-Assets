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

:rel_up
cls
set /p f1="File ka naam dalo: "
set /p t1="Tag Name dalo: "
gh release upload %t1% "%f1%"
pause
goto menu

:rel_rep
cls
set /p f2="File ka naam dalo: "
set /p t2="Tag Name dalo: "
gh release upload %t2% "%f2%" --clobber
pause
goto menu

:img_up
cls
pushd ..
git init >nul 2>&1
git remote add origin %REPO_URL% >nul 2>&1
popd
set /p i1="Image ka naam dalo: "
git add "%i1%"
git commit -m "Added new image: %i1%"
git push origin main
pause
goto menu

:img_rep
cls
pushd ..
git init >nul 2>&1
git remote add origin %REPO_URL% >nul 2>&1
popd
set /p i2="Image ka naam dalo: "
git add "%i2%"
git commit -m "Replaced image: %i2%"
git push origin main
pause
goto menu

:fold_up
cls
echo [UPLOADING ENTIRE FOLDER...]
pushd ..
:: Ye line error khatam karegi
git init
git remote add origin %REPO_URL% >nul 2>&1
git fetch origin main >nul 2>&1
git checkout main >nul 2>&1 || git checkout -b main
git add .
set /p m1="Description dalo: "
git commit -m "%m1%"
git push origin main
popd
echo ------------------------------------------
echo KAAM HO GAYA BHAI!
pause
goto menu

:fold_rep
cls
echo [REFRESHING ENTIRE FOLDER...]
pushd ..
git init
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%
git add .
set /p m2="Description dalo: "
git commit -m "%m2%"
git push origin main --force
popd
echo ------------------------------------------
echo FULL REFRESH DONE!
pause
goto menu