#!/bin/bash
set -e

if [[ "${is_debug}" == "yes" ]] ; then
  set -x
fi

curl_quiet_param="-sS"
if [[ "${is_debug}" == "yes" ]] ; then
  curl_quiet_param=""
fi

package_name_param=""
if [ ! -z "${bundle_id}" ] ; then
  package_name_param="-p"
fi

echo "Calculator version: ${calculator_version}"
echo "Application path: ${application_path}"
echo "Temporary path: ${temporary_path}"

calculator_url="https://repo.onegini.com/artifactory/onegini-sdk/com/onegini/mobile/sdk/android/android-app-signature-calculator/${calculator_version}/android-app-signature-calculator-${calculator_version}.jar"
calculator_download_path="${temporary_path}/android-app-signature-calculator-${calculator_version}.jar"

curl ${curl_quiet_param} -u ${onegini_artifactory_username}:${onegini_artifactory_password} ${calculator_url}  -o ${calculator_download_path}
application_thumbprint=$(java -jar ${calculator_download_path} ${application_path} -q ${package_name_param} ${package_name})
envman add --key ONEGINI_APP_THUMBPRINT --value "${application_thumbprint}"