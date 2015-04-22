set CF_RAISE_ERROR_ON_WARNINGS=true

set CONFIG_DIR=%CD%

set BASE_GOPATH=%CD%\gopath

set GOPATH=%CD%\gopath
set PATH=%GOPATH%\bin;%PATH%
set CF_RELEASE_DIR=%CD%/cf-release

set API_ENDPOINT=https://api.%BOSH_LITE_IP%.xip.io
set APPS_DOMAIN=%BOSH_LITE_IP%.xip.io
set ADMIN_USER=admin
set ADMIN_PASSWORD=admin
set CF_USER=user
set CF_PASSWORD=userpassword
set CF_ORG=cli-cats-org
set CF_SPACE=cli-cats-space

set CONFIG=%CONFIG_DIR%\config.json

echo {> %CONFIG%
echo "api": "%API_ENDPOINT%",>> %CONFIG%
echo "apps_domain": "%APPS_DOMAIN%",>> %CONFIG%
echo "admin_user": "%ADMIN_USER%",>> %CONFIG%
echo "admin_password": "%ADMIN_PASSWORD%",>> %CONFIG%
echo "cf_user": "%CF_USER%",>> %CONFIG%
echo "cf_user_password": "%CF_USER_PASSWORD%",>> %CONFIG%
echo "cf_org": "%CF_ORG%",>> %CONFIG%
echo "cf_space": "%CF_SPACE%",>> %CONFIG%
echo "skip_ssl_validation": true,>> %CONFIG%
echo "persistent_app_host": "persistent-app-win64",>> %CONFIG%
echo "default_timeout": 120,>> %CONFIG%
echo "cf_push_timeout": 210,>> %CONFIG%
echo "long_curl_timeout": 210,>> %CONFIG%
echo "broker_start_timeout": 330>> %CONFIG%
echo }>> %CONFIG%

mkdir %GOPATH%\src\github.com\cloudfoundry
set CATSPATH=%GOPATH%\src\github.com\cloudfoundry\cf-acceptance-tests
move .\cf-release\src\acceptance-tests %CATSPATH%

mkdir %CATSPATH%\bin

cd gopath\src\github.com\cloudfoundry\cli

set ORIGINAL_GOPATH=%GOPATH%
set GOPATH=%BASE_GOPATH%;%CD%\Godeps\_workspace

go get github.com/jteeuwen/go-bindata/... || exit /b 1
go-bindata -pkg resources -ignore ".go" -o cf/resources/i18n_resources.go cf/i18n/resources/... cf/i18n/test_fixtures/... || exit /b 1

go build -v -o %CATSPATH%\bin\cf.exe ./main || exit /b 1

set GOPATH=%ORIGINAL_GOPATH%
cd %CONFIG_DIR%

set CATS_DEPS_GOPATH=%CATSPATH%\Godeps\_workspace
mkdir %CATS_DEPS_GOPATH%\bin

set GOPATH=%CATS_DEPS_GOPATH%;%GOPATH%
set PATH=%CATS_DEPS_GOPATH%\bin;%CATSPATH%\bin;%PATH%

cd %CATSPATH%

go install github.com/onsi/ginkgo/ginkgo || exit /b 1

ginkgo -r -slowSpecThreshold=120 -skipPackage="logging,services,v3" -skip="go makes the app reachable via its bound route|SSO|takes effect after a restart, not requiring a push|doesn't die when printing 32MB|exercises basic loggregator|firehose data"
