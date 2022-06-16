MAVProxy Docker
===============

Containerized [MAVProxy](https://ardupilot.org/mavproxy/index.html).

[DockerHub](https://hub.docker.com/repository/docker/sitin/mavproxy).

This image is inspired by [asciich/mavproxy](https://hub.docker.com/r/asciich/mavproxy) and tries to remove some of its
limitations.

Designed to be used with [sitin/ardupilot-sitl](https://hub.docker.com/repository/docker/sitin/ardupilot-sitl).

Usage
-----

If you have MAVLink master on host 5760, then you can start simply:

```shell
docker run -it sitin/mavproxy
```

This will broadcast to your host UDP 14550 (default behavior).

You can omit `-it` if you don't want to connect to console.

If you want to select another master or additional output:

```shell
docker run -it sitin/mavproxy --master=--master=tcp:host.docker.internal:5761 --out=udp:host.docker.internal:14551
```

> **NOTE!**
>
> If you want to suppress default UDP broadcast to `host.docker.internal:14551`, you need to rewrite container 
> [entry point]([`Dockerfile`](Dockerfile)).

Check [`docker-compose.yml`](docker-compose.yml) and [`Dockerfile`](Dockerfile) for details.

### Devices

You can configure Docker to connect to devices (i.e. USB). For example, for `/dev/ttyUSB0`:

```shell
docker run --rm --device=/dev/ttyUSB0 -it sitin/mavproxy --master=/dev/ttyUSB0,57600
```

Some available devices:
 
- `/dev/ttyUSB0`
- `/dev/ttyAMA0`
- `/dev/ttyACM0`

### X11

Set `DISPLAY=host.docker.internal:0` and configure your host X11 to accept connections. For OS X see 
[manual](https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb).
