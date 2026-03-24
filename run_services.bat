@echo off
echo Starting PSAI Application Services...

cd /d "%~dp0"

:: Check and create virtual environment
if not exist "psai_venv\Scripts\activate.bat" (
    echo Creating virtual environment psai_venv...
    python -m venv psai_venv
    echo Installing requirements...
    call "psai_venv\Scripts\activate.bat"
    if exist requirements.txt (
        pip install -r requirements.txt
    ) else if exist pyproject.toml (
        pip install -e .
    )
)

:: Start Backend API
:: We activate the virtual environment first
:: We set PYTHONPATH to the parent directory so that 'import psai' works if running from source without installation
start "PSAI Backend API" cmd /k call "%~dp0psai_venv\Scripts\activate.bat" ^&^& cd /d "%~dp0" ^&^& python run_backend.py

:: Check frontend dependencies
if not exist "frontend\node_modules\" (
    echo Installing frontend dependencies...
    cd /d "%~dp0frontend"
    call npm install
    cd /d "%~dp0"
)

:: Start Frontend
start "PSAI Frontend" cmd /k "cd /d "%~dp0frontend" && npm run dev"

echo Services started in separate windows.
