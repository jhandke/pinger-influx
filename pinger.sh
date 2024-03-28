#!/bin/bash
# Ping Tool with InfluxDB output

echo "INFO: Starting pinger Ping Tool."

output=$(ping -c $PINGER_COUNT -q -n -t $PINGER_TIMEOUT $PINGER_HOST | grep -e "round-trip")
ret=$?
if [ $ret -ne 0 ]; 
then
    echo "ERROR: Ping failed!"
else
    echo "INFO: Ping successful."

    output=${output##*=}
    output=${output%*ms}
    IFS=/ read min avg max stddev <<< "$output"
    min=${min//[[:blank:]]/}

    echo "INFO: Average ping to" $PINGER_HOST "was:" $avg "ms"
    echo "INFO: Sending values to InfluxDB..."

    timestamp=$(date +%s)
    influx_url="${PINGER_INFLUX_HOST}/api/v2/write?bucket=${PINGER_INFLUX_DB}&precision=s"
    influx_auth="${PINGER_INFLUX_USER}:${PINGER_INFLUX_PASSWORD}"

    curl -s --no-keepalive -XPOST $influx_url --data-binary "ping_min,host=${PINGER_HOST} value=${min} ${timestamp}" -u "$influx_auth";
    curl -s --no-keepalive -XPOST $influx_url --data-binary "ping_avg,host=${PINGER_HOST} value=${avg} ${timestamp}" -u "$influx_auth";
    curl -s --no-keepalive -XPOST $influx_url --data-binary "ping_max,host=${PINGER_HOST} value=${max} ${timestamp}" -u "$influx_auth";
    curl -s --no-keepalive -XPOST $influx_url --data-binary "ping_std,host=${PINGER_HOST} value=${stddev} ${timestamp}" -u "$influx_auth";

    echo "INFO: Done. Quitting pinger Ping Tool."
fi