SET GOPATH=%CD%\gopath
SET PATH=%PATH%;%CD%\gopath\bin

cd gopath\src\github.com\cloudfoundry\cli

SET GODEPSPATH=%CD%\Godeps\_workspace
SET GOPATH=%GODEPSPATH%;%GOPATH%;
SET PATH=%PATH%;%GODEPSPATH%\bin

go get github.com/jteeuwen/go-bindata/... || exit /b 1
go-bindata -pkg resources -ignore ".go" -o cf/resources/i18n_resources.go cf/i18n/resources/... cf/i18n/test_fixtures/... || exit /b 1

powershell -command set-executionpolicy remotesigned || exit /b 1
powershell .\bin\replace-sha.ps1 || exit /b 1

go build -v -o %CF_EXE_NAME% ./main || exit /b 1

go install github.com/onsi/ginkgo/ginkgo || exit /b 1

ginkgo -cover -nodes 4 -v -r ./cf ./generic ./testhelpers ./main
