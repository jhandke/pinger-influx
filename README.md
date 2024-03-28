# Pinger
Ping Tool to check the availability of a specific host.

This program pings a host regularly and reports the results to InfluxDB.

## Setup
Build the Docker image and deploy it with the following docker-compose.yaml:

```
version: "3"
services:
  pinger:
    image: <WHATEVER_YOU_TAGGED_YOUR_IMAGE_WITH>
    environment:
      - PINGER_HOST=<HOST_TO_PING>
      - PINGER_COUNT=<NUMBER_OF_PINGS>
      - PINGER_TIMEOUT=<TIMEOUT_FOR_PING>
      - PINGER_INFLUX_HOST=http://<YOUR_INFLUXDB_HOST>:8086
      - PINGER_INFLUX_DB=<INFLUXDB_DATABASE_OR_BUCKET>
      - PINGER_INFLUX_USER=<INFLUXDB_USER>
      - PINGER_INFLUX_PASSWORD=<INFLUXDB_PASSWORD>
```

## Misc
This program was written during a two-day internet outage in March 2024. If you find something to improve, do not hesitate to create a pull request :)