DOCKER_IMAGE_NAME=$1

# If script run to error, exist -1;
function _do() 
{
        "$@" || { echo "exec failed: ""$@"; exit -1; }
}

echo "INFORMATION - AquaSec Scanner-cli......" 
echo "INFORMATION - AquaSec Scanner-cli......" >> result.log
echo "========================================" 
echo "========================================" >> result.log

if [ $DOCKER_ACCOUNT == $PROD_DOCKER_ACCOUNT ]; then #It's master branch
    echo "This is Master Branch, SKIP this process......"
    echo "This is Master Branch, SKIP this process......" >> result.log
    echo "========================================"
    echo "========================================" >> result.log
    exit 0
fi

echo "DOCKER_IMAGE_NAME: ${DOCKER_IMAGE_NAME}"

AQUASEC_CONTAINRE="${DOCKER_ACCOUNT}"/scanner-cli:3.0
AQUASEC_SITE="http://aquasecscan.westus2.cloudapp.azure.com:8080"
AQUASEC_USER="administrator"
AQUASEC_PASSWORD='Vpn12345!2345'

_do docker run -v /var/run/docker.sock:/var/run/docker.sock ${AQUASEC_CONTAINRE}\
    -H ${AQUASEC_SITE} -U ${AQUASEC_USER} -P ${AQUASEC_PASSWORD} \
    --local ${DOCKER_IMAGE_NAME} \
    --register --registry local_scanner > _do scan_log.json

_do cat scan_log.json

testResult=$(jq '.image_assurance_result | .disallowed' scan_log.json)
if [ ! -z "$testResult" ]; then
   echo "FAILED - Docker pull and run Failed!!!"
   echo "FAILED - Docker pull and run Failed!!!" >> result.log
   echo $(jq '.image_assurance_result' scan_log.json)
   echo $(jq '.image_assurance_result' scan_log.json) >> result.log   
else
   echo "PASSED - No high vulnerability is found !"
   echo "PASSED - No high vulnerability is found !" >> result.log
fi

exit 0


