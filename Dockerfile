FROM ubuntu:18.04

MAINTAINER Mykhailo Ziatin <mikhail.zyatin@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN echo "UTC" > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
        python-dev \
        python-opencv \
        python-wxgtk3.0 \
        python-pip \
        python-matplotlib \
        python-pygame \
        python-lxml \
        python-yaml \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && \
    pip install --upgrade setuptools

ARG MAVPROXY_TAG
RUN pip install --upgrade MAVProxy==$(echo ${MAVPROXY_TAG} | awk -Fv '{ print $0 }')

RUN mkdir -p "/mavproxy" && \
    mkdir -p /var/log/mavproxy/
WORKDIR /mavproxy

COPY ./contents/* .

# Make all the scripts exacutable and move to /usr/bin
RUN for script in $(ls ./*.sh) ; do \
        chmod +x ${script} && \
        dest=$(basename $(echo ${script} | sed 's#.sh##g')) && \
        mv -v ${script} /usr/bin/${dest} && \
        echo "SCRIPT: ${script} > /usr/bin/${dest}" >> /var/log/buld.log \
    ; done

ENTRYPOINT [ "run-mavproxy" ]
CMD [ ]
