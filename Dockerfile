# Base image
FROM ubuntu:latest

# Metadata
LABEL maintainer="Yucheng Zhang <zhan4429@purdue.edu>" \
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
        openjdk-17-jdk \
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

# Create non-root user for security
RUN useradd -m igvuser && chown -R igvuser:igvuser /opt

# Switch to non-root user
USER igvuser

# Set working directory
WORKDIR $IGV_DIR

# Default command
ENTRYPOINT ["./igv.sh"]
CMD []