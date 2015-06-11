echo "IN win32_test.bat 1"

SET GOPATH=%CD%\gopath
SET PATH=%PATH%;%CD%\gopath\bin

cd gopath\src\github.com\cloudfoundry\cli

SET GODEPSPATH=%CD%\Godeps\_workspace
SET GOPATH=%GODEPSPATH%;%GOPATH%;
SET PATH=%PATH%;%GODEPSPATH%\bin

echo "IN win32_test.bat 2"
go get github.com/jteeuwen/go-bindata/... || exit /b 1
echo "IN win32_test.bat 3"
go-bindata -pkg resources -ignore ".go" -o cf/resources/i18n_resources.go cf/i18n/resources/... cf/i18n/test_fixtures/... || exit /b 1
echo "IN win32_test.bat 4"

powershell -command set-executionpolicy remotesigned < NUL || exit /b 1
powershell .\bin\replace-sha.ps1 < NUL || exit /b 1

echo "IN win32_test.bat 5"
go build -v -o %CF_EXE_NAME% ./main || exit /b 1

echo "IN win32_test.bat 6"
REM go install github.com/onsi/ginkgo/ginkgo || exit /b 1

REM ginkgo -cover -r ./cf ./generic ./testhelpers ./main
