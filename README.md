# Pinger
Ping Tool to check the availability of a specific host.

This application pings a host regularly and reports the results to InfluxDB.

## Setup
Deploy the application with the following docker-compose.yaml:

```YAML
version: "3"
services:
  pinger:
    image: ghcr.io/jhandke/pinger-influx:main
    restart: unless-stopped
    environment:
      - PINGER_HOST=<HOST_TO_PING>
      - PINGER_COUNT=<NUMBER_OF_PINGS>
      - PINGER_INFLUX_HOST=http://<YOUR_INFLUXDB_HOST>:8086
      - PINGER_INFLUX_DB=<INFLUXDB_DATABASE_OR_BUCKET>
      - PINGER_INFLUX_USER=<INFLUXDB_USER>
      - PINGER_INFLUX_PASSWORD=<INFLUXDB_PASSWORD>
```

## Misc
This program was written during a two-day internet outage in March 2024. If you find something to improve, do not hesitate to create a pull request :)