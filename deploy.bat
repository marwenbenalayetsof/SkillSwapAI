@echo off
echo ========================================
echo  SkillSwapAI - Firebase Hosting Deploy
echo ========================================
echo.

where npx >nul 2>&1 || (
    echo ERROR: Node.js is not installed!
    echo Please install from https://nodejs.org first.
    pause
    exit /b 1
)

echo Installing Firebase CLI...
call npx firebase-tools login

echo.
echo Deploying to Firebase Hosting...
call npx firebase-tools deploy --project flutter-test-12345 --only hosting

echo.
echo Done! Your app is live at:
echo   https://flutter-test-12345.web.app
echo   https://skillswap-ai-marwen.web.app
pause
