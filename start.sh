#!/usr/bin/env bash

LOCUST_MASTER_OR_SLAVE=${LOCUST_MASTER_OR_SLAVE:-master}
LOCUST_TEST_HOST=${LOCUST_TEST_HOST:-localhost}
LOCUST_REQUESTS=${LOCUST_REQUESTS:-100}
LOCUST_CONCURRENT_CLIENTS=${LOCUST_CONCURRENT_CLIENTS:-1}
LOCUST_REQUEST_RATE=${LOCUST_REQUEST_RATE:-1}

# Stop on the first error
set -e;

function onExit {
    if [ "$?" != "0" ]; then
        echo "Stress tests failed!";
        exit 1
    else
        echo "Stress tests passed!";
        exit 0
    fi
}

# Call onExit when the script exits
trap onExit EXIT;

if [ "${LOCUST_MASTER_OR_SLAVE}" = "slave" ] && [ "${LOCUST_MASTER_HOST}" != "" ]; then
	locust -f ${LOCUST_TESTS} \
	  --${LOCUST_MASTER_OR_SLAVE} \
	  --master-host=${LOCUST_MASTER_HOST} \
	  --host=${LOCUST_TEST_HOST} \
	  -n${LOCUST_REQUESTS} \
	  -c${LOCUST_CONCURRENT_CLIENTS} \
	  -r${LOCUST_REQUEST_RATE} \
	  ${LOCUST_ADDITIONAL_OPTIONS}	
else if [ "${LOCUST_MASTER_OR_SLAVE}" = "slave" ] && [ "${LOCUST_MASTER_HOST}" = "" ]; then
	echo "Please provide a LOCUST_MASTER_HOST variable for Locust slaves"
else if [ "${LOCUST_MASTER_OR_SLAVE}" = "master" ]; then
	locust -f ${LOCUST_TESTS} \
	  --${LOCUST_MASTER_OR_SLAVE} \
	  --host=${LOCUST_TEST_HOST} \
	  -n${LOCUST_REQUESTS} \
	  -c${LOCUST_CONCURRENT_CLIENTS} \
	  -r${LOCUST_REQUEST_RATE} \
	  ${LOCUST_ADDITIONAL_OPTIONS}
else
    echo "Please provide a LOCUST_MASTER_HOST variable for Locust slaves"
fi


