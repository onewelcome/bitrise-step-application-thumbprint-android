#!/bin/bash
set -e

if [[ "${is_debug}" == "yes" ]] ; then
  set -x
fi

curlQuietParam="-sS"
unzipQuietParam="-q"
if [[ "${is_debug}" == "yes" ]] ; then
  curlQuietParam=""
  unzipQuietParam=""
fi

echo "Calculator version: ${calculator_version}"
echo "Application path: ${application_path}"
echo "Temporary path: ${temporary_path}"

calculator_url="https://repo.onegini.com/artifactory/onegini-sdk/com/onegini/mobile/sdk/android/android-app-signature-calculator/${calculator_version}/android-app-signature-calculator-${calculator_version}.jar"
calculator_download_path="${temporary_path}/android-app-signature-calculator-${calculator_version}.jar"

curl ${curlQuietParam} -u ${onegini_artifactory_username}:${onegini_artifactory_password} ${calculator_url}  -o ${calculator_download_path}
application_thumbprint=$(java -jar ${calculator_download_path} ${application_path} -q)
envman add --key ONEGINI_APP_THUMBPRINT --value "${application_thumbprint}"