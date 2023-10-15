#!/bin/bash

export JMETER_VERSION=5.6.2

# Đặt timestamp cho việc lưu trữ kết quả và logs
export timestamp=$(date +%Y%m%d_%H%M%S)

# Đường dẫn trên máy host tới thư mục chứa scripts JMeter
export volume_path=$(pwd)/jmeter-scripts

# Đường dẫn trong container mà volume trên sẽ được mount vào
export jmeter_path=/mnt/jmeter
 	

# Xác định xem bạn muốn chạy ở chế độ GUI hay không
read -p "Bạn muốn chạy JMeter ở chế độ GUI (y/n)? " choice

if [[ $choice == "y" ]]; then
  # Chạy JMeter ở chế độ GUI với X11 forwarding
  sudo docker run \
    --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/.Xauthority:/root/.Xauthority \
    --volume "${volume_path}":${jmeter_path} \
    --name jmeter-gui \
    jmeter:latest
else
  # Chạy JMeter không dùng GUI
  docker run \
    --rm \
    --volume "${volume_path}":${jmeter_path} \
    jmeter:latest \
    -n \
    -t ${jmeter_path}/example.jmx \
    -JINFLUXDB_HOST="host.docker.internal" \
    -l ${jmeter_path}/results/result_${timestamp}.jtl \
    -j ${jmeter_path}/results/jmeter_${timestamp}.log
fi

