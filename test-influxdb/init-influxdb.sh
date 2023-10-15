#!/bin/bash

# Install jq if it is not installed
if ! command -v jq &> /dev/null; then
    apt-get update && apt-get install -y jq
fi

# Wait for InfluxDB to be ready
until curl -s http://influxdb:8086/health -o /dev/null; do
    sleep 1
done

# Function to check if a bucket exists
bucket_exists() {
    local bucket_name="$1"
    local existing_buckets
    existing_buckets=$(influx bucket list --host http://influxdb:8086 --token my-secret-token --org MainOrg -o json | jq -r '.[] | .name')
    for bucket in $existing_buckets; do
        if [ "$bucket" == "$bucket_name" ]; then
            return 0 # Bucket exists
        fi
    done
    return 1 # Bucket does not exist
}

# Create bucket collectd if it doesn't exist
if ! bucket_exists "collectd"; then
    echo "Creating bucket collectd..."
    influx bucket create --host http://influxdb:8086 --token my-secret-token --name collectd --org MainOrg
fi

# Create bucket jmeter_result if it doesn't exist
if ! bucket_exists "jmeter_result"; then
    echo "Creating bucket jmeter_result..."
    influx bucket create --host http://influxdb:8086 --token my-secret-token --name jmeter_result --org MainOrg
fi

# Generate and save admin token (optional)
#admin_token=$(influx auth create --host http://influxdb:8086 --username jmeter --password jmeterpassword --org MainOrg --read-buckets=\* --write-buckets=\*)
#echo "Generated Admin Token: ${admin_token}" > /tokens/admin_token.txt

