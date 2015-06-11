echo "MJS IN windowns32-unit.bat 1"
set root=%CD%

set /p VERSION=<version\number

echo "IN windowns32-unit.bat 2"
call gopath\src\github.com\cloudfoundry\cli\bin\win32_test.bat || exit /b 1
echo "IN windowns32-unit.bat 3"

cd %root%

move /y gopath\src\github.com\cloudfoundry\cli\%CF_EXE_NAME% cf-windows%BITS%-%VERSION%.exe
