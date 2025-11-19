@echo off
echo Running Dart Analyzer...
echo.
flutter analyze > analyzer_report.txt
echo.
echo Analyzer report saved to analyzer_report.txt
echo.
type analyzer_report.txt
echo.
pause
