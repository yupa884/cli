SET GOPATH=%CD%\gopath
SET PATH=%PATH%;%CD%\gopath\bin

cd gopath\src\github.com\cloudfoundry\cli

SET GODEPSPATH=%CD%\Godeps\_workspace
SET GOPATH=%GODEPSPATH%;%GOPATH%;

go get github.com/jteeuwen/go-bindata/... || exit /b
go-bindata -pkg resources -ignore ".go" -o cf/resources/i18n_resources.go cf/i18n/resources/... cf/i18n/test_fixtures/... || exit /b

powershell -command set-executionpolicy remotesigned || exit /b
powershell .\bin\replace-sha.ps1 || exit /b

go build -v -o %CF_EXE_NAME% ./main || exit /b
go test -i ./cf/... ./generic/... ./testhelpers/... || exit /b
go test -cover -v ./cf/... ./generic/... ./testhelpers/... ./main/... || exit /b
