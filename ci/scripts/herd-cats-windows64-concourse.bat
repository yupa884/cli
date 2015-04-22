SET CF_RAISE_ERROR_ON_WARNINGS=true

SET CONFIG_DIR=%CD%

SET GOPATH=%CD%/gopath
SET PATH=%GOPATH%/bin;%PATH%
SET CF_RELEASE_DIR=%CD%/cf-release

SET API_ENDPOINT=https://api.%BOSH_LITE_IP%.xip.io
SET APPS_DOMAIN=%BOSH_LITE_IP%.xip.io
SET ADMIN_USER=admin
SET ADMIN_PASSWORD=admin
SET CF_USER=user
SET CF_PASSWORD=userpassword
SET CF_ORG=cli-cats-org
SET CF_SPACE=cli-cats-space

SET CONFIG=%CONFIG_DIR%\config.json

.\cf-cli\ci\scripts\create-cats-config.bat

SET CATSPATH=%GOPATH%\src\github.com\cloudfoundry\cf-acceptance-tests
MKDIR %CATSPATH%

MOVE .\cf-release\src\acceptance-tests %CATSPATH%

MKDIR %CATSPATH%\bin

cd gopath\src\github.com\cloudfoundry\cli
go build -v -o %CATSPATH%/bin/cf.exe ./main || exit /b 1
cd %CONFIG_DIR%

SET CATS_DEPS_GOPATH=%CATSPATH%\Godeps\_workspace
MKDIR %CATS_DEPS_GOPATH%\bin

SET GOPATH=%CATS_DEPS_GOPATH%;%GOPATH%
SET PATH=%CATS_DEPS_GOPATH%\bin;%CATSPATH%\bin;%PATH%

CD %CATSPATH%

go get -v github.com/onsi/ginkgo/ginkgo
ginkgo -r -slowSpecThreshold=120 -skipPackage="logging,services,v3" -skip="go makes the app reachable via its bound route|SSO|takes effect after a restart, not requiring a push|doesn't die when printing 32MB|exercises basic loggregator|firehose data"
