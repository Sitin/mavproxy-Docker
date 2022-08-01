MAVProxy Docker
===============

[![Publish Docker](https://github.com/Sitin/mavproxy-Docker/actions/workflows/main.yml/badge.svg)](https://github.com/Sitin/mavproxy-Docker/actions/workflows/main.yml)
[![Update latest tag according to mavp2p](https://github.com/Sitin/mavproxy-Docker/actions/workflows/update-tags.yml/badge.svg)](https://github.com/Sitin/mavproxy-Docker/actions/workflows/update-tags.yml)

Containerized [MAVProxy](https://ardupilot.org/mavproxy/index.html).

[DockerHub](https://hub.docker.com/repository/docker/sitin/mavproxy).

This image is inspired by [asciich/mavproxy](https://hub.docker.com/r/asciich/mavproxy) and tries to remove some of its
limitations.

Usage
-----

If you have MAVLink device transmitting to host UDP 14540, then you can start with:

```shell
docker run -it sitin/mavproxy --master=udp:host.docker.internal:14540
```

You can omit `-it` if you don't want to connect to console.

Container supports all MAVProxy parameters. For example, if you want to proxy your connection to UDP 14551:

```shell
docker run -it sitin/mavproxy --master=udp:host.docker.internal:14540 --out=udp:host.docker.internal:14551
```

### Devices

You can configure Docker to connect to devices (i.e. USB). For example, for `/dev/ttyUSB0`:

```shell
docker run --rm --device=/dev/ttyUSB0 -it sitin/mavproxy --master=/dev/ttyUSB0,57600
```

Some available devices:
 
- `/dev/ttyUSB0`
- `/dev/ttyAMA0`
- `/dev/ttyACM0`

### Volumes

You can save logs and state of MAVProxy by adding the following volumes:

- <path to logs>:/var/log/mavproxy
- <path to MAVProxy state>:/mavproxy

### X11

Set `DISPLAY=host.docker.internal:0` and configure your host X11 to accept connections. For OS X see 
[manual](https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb).
