#!/usr/bin/env python3
import json
import urllib.request


def versions(package_name):
    url = "https://pypi.org/pypi/%s/json" % (package_name,)
    data = json.load(urllib.request.urlopen(urllib.request.Request(url)))
    versions = list(data["releases"].keys())
    return versions


def latest_version(package_name):
    versions_splitted = [[int(item) for item in version.split('.')] for version in versions(package_name)]
    versions_splitted = sorted(versions_splitted, key=lambda x: (x[1], x[2], x[0]))
    last_version = versions_splitted[-1]
    return ".".join([str(item) for item in last_version])


if __name__ == '__main__':
    print(latest_version("MAVProxy"))
