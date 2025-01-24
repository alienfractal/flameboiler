@echo off

rem ---------------------------
rem Batch convert WAV to MP3
rem ---------------------------

for %%F in (*.wav) do (
    ffmpeg -i "%%F" "%%~nF.mp3"
)

echo.
echo Conversion complete!
pause