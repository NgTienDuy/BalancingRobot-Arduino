@echo off
REM ============================================================
REM  flash.bat - Nap .hex qua bootloader Arduino bang avrdude
REM  CodeVision se goi file nay o muc After Make.
REM
REM  >>> SUA 4 DONG DUOI CHO DUNG MAY BAN <<<
REM  - AVRDUDE / CONF: lay tu thu muc cai Arduino IDE
REM  - PORT: xem trong Device Manager (vd COM5)
REM  - BAUD: 115200 (optiboot). Neu loi "not in sync" -> doi 57600
REM ============================================================

set AVRDUDE="C:\Program Files (x86)\Arduino\hardware\tools\avr\bin\avrdude.exe"
set CONF="C:\Program Files (x86)\Arduino\hardware\tools\avr\etc\avrdude.conf"
set PORT=COM5
set BAUD=115200
set HEX="Exe\Self_Balancing_Rover.hex"

echo ============================================
echo  Nap %HEX%
echo  Cong %PORT% @ %BAUD% baud
echo ============================================
%AVRDUDE% -C %CONF% -c arduino -p m328p -P %PORT% -b %BAUD% -U flash:w:%HEX%:i

echo.
if errorlevel 1 (
  echo [LOI] Nap that bai. Thu: doi BAUD=57600, kiem tra dung COM, dong Serial Monitor.
) else (
  echo [OK] Nap xong.
)
pause
