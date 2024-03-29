#!/bin/bash

# Pinger: Ping Tool with InfluxDB output
# Copyright (C) 2024 Jakob Handke
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


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