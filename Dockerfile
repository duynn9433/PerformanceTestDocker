version: '3.8'

services:
  influxdb:
    image: influxdb:2.7.1
    ports:
      - "8086:8086"
      - 25826:25826/udp
    environment:
      - DOCKER_INFLUXDB_INIT_MODE=setup
      - DOCKER_INFLUXDB_INIT_USERNAME=jmeter
      - DOCKER_INFLUXDB_INIT_PASSWORD=jmeterpassword
      - DOCKER_INFLUXDB_INIT_ORG=MainOrg
      - DOCKER_INFLUXDB_INIT_BUCKET=jmeter_bucket
      - DOCKER_INFLUXDB_INIT_RETENTION_POLICY=autogen
      - DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=my-secret-token
    volumes:
      - influxdb-data:/var/lib/influxdb2
      - ./tokens:/tokens
    networks:
      - jmeter-net

  init-influxdb:
    image: quay.io/influxdb/influxdb:2.7.1
    depends_on:
      - influxdb
    volumes:
      - ./init-influxdb.sh:/init-influxdb.sh
      - ./tokens:/tokens
    entrypoint: /bin/bash -c "chmod +x /init-influxdb.sh && /init-influxdb.sh"

volumes:
  influxdb-data:
networks:
  jmeter-net:
    driver: bridge
