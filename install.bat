@echo off
python -m venv .venv
call .venv\Scripts\activate.bat
python -m pip install -U pip wheel
pip install -r requirements.txt
