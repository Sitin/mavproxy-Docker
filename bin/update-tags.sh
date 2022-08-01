#!/usr/bin/env sh

set -e

###############################################################################
# Config
###############################################################################

repo_url=https://github.com/Sitin/mavproxy-Docker.git

###############################################################################
# Getting the latest tags
###############################################################################

latest_tag=$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' "${repo_url}" \
            | tail --lines=1 \
            | awk -F/ '{ print $3 }')

latest_mavproxy_tag="v$(./bin/get_latest_tag.py)"

echo "Latest tag: '${latest_tag}'. Latest mavp2p tag: '${latest_mavproxy_tag}'."

###############################################################################
# Set latest mavp2p tag if not set
###############################################################################

if [ "${latest_tag}" = "${latest_mavproxy_tag}" ]; then
  echo "Latest tags are in sync, nothing to update."
else
  echo "Setting the latest git tag to '${latest_mavproxy_tag}'."
  git tag "${latest_mavproxy_tag}"
fi
