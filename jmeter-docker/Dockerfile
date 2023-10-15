# Use Java 8 slim JRE as the base image
FROM openjdk:8-jre-slim

# Maintainer info
MAINTAINER DuynnJmeterMaster 

# JMeter version
ARG JMETER_VERSION=5.6.2

# Environment variables
ENV JMETER_HOME /opt/apache-jmeter-$JMETER_VERSION
ENV JMETER_BIN  $JMETER_HOME/bin
ENV PATH $PATH:$JMETER_BIN

# Install utilities and libraries
RUN apt-get update && \
    apt-get -qy install \
                wget \
                telnet \
                iputils-ping \
                unzip \
                fontconfig \
                fonts-dejavu \
                libxext6 \
                libxrender1 \
                libxtst6 \
                libxi6 \
                libxext-dev \
                libxrender-dev \
                libfreetype6 && \
    rm -rf /var/lib/apt/lists/*

# Create JMeter directory
RUN mkdir -p /opt

# Copy JMeter tarball into the image
COPY apache-jmeter-$JMETER_VERSION.tgz /opt/apache-jmeter-$JMETER_VERSION.tgz

# Extract JMeter
RUN cd /opt/ && \
    tar -xzf apache-jmeter-$JMETER_VERSION.tgz && \
    rm apache-jmeter-$JMETER_VERSION.tgz

# Copy the customized launch script to optimize memory usage
COPY launch.sh /

# Ports to be exposed from the container for JMeter Master
EXPOSE 60000

# Set the entrypoint to use the customized launch script
# Uncomment this if you want to run the launch.sh script as the entrypoint
ENTRYPOINT ["/launch.sh"]

