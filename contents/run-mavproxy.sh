#!/usr/bin/env bash

set -e

session_name=$(date "+%Y-%m-%d_%H-%M-%S")
log_dir="/var/log/mavproxy/"
log_file_name="${log_dir}/${session_name}-mavproxy.log"

mkdir -p "${session_name}"
cd "${session_name}"

mavproxy.py --logfile="${log_file_name}" "${@}"
