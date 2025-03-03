# Base image
FROM ubuntu:24.04

# Metadata
LABEL maintainer="Yucheng Zhang <yzhang85@tufts.edu>" \
      version="v2.19.1" \
      description="Container with IGV version 2.19.1."

# Set environment variables
ENV TZ=America/Indiana/Indianapolis \
    DEBIAN_FRONTEND=noninteractive \
    IGV_VERSION=2.19.1 \
    IGV_DIR=/opt/IGV_2.19.1 \
    PATH=/opt/IGV_2.19.1:$PATH

# Install dependencies, download IGV, and clean up
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends \
        build-essential \
        wget \
        unzip \
        openjdk-21-jdk \
        ca-certificates && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    mkdir -p $IGV_DIR && \
    wget --no-cache -q https://data.broadinstitute.org/igv/projects/downloads/2.19/IGV_${IGV_VERSION}.zip -O /tmp/IGV.zip && \
    unzip /tmp/IGV.zip -d /opt && \
    rm /tmp/IGV.zip && \
    chmod +x $IGV_DIR/*.sh && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

