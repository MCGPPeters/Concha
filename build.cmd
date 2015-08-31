@echo off
powershell -NoProfile -ExecutionPolicy RemoteSigned -Command ".\build\build.ps1 -Configuration "  %1