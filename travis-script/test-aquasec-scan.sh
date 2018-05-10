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

AQUASEC_CONTAINRE="${DOCKER_ACCOUNT}"/scanner-cli:2.6.4
AQUASEC_SITE="http://aquasecscan.westus2.cloudapp.azure.com:8080"
AQUASEC_USER="administrator"
AQUASEC_PASSWORD='Vpn12345!2345'

_do docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
  ${AQUASEC_CONTAINRE} \
  --user ${AQUASEC_USER} --password ${AQUASEC_PASSWORD} --host ${AQUASEC_SITE} \
  --local --image testdocker > scan_log.json

_do cat scan_log.json

testResult=$(cat scan_log.json | grep "DisAllower")
if [ ! -z "$testResult" ]; then
   echo "FAILED - Docker pull and run Failed!!!"
   exit -1
else
   echo "PASSED - Docker image pull and run Successfully!. You can manually verify it!"
   echo "PASSED - Docker image pull and run Successfully!. You can manually verify it!" >> result.log
fi

exit 0


