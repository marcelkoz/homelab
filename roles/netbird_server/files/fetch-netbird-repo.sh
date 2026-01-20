#!/usr/bin/env bash

# https://docs.netbird.io/selfhosted/selfhosted-guide

REPO='https://github.com/netbirdio/netbird/'
# this command will fetch the latest release e.g. v0.8.7
LATEST_TAG=$(basename $(curl -fs -o/dev/null -w %{redirect_url} ${REPO}releases/latest))
echo $LATEST_TAG

# delete the existing netbird repo
if [ -d 'netbird' ]; then
    rm -rf netbird
fi

# this command will clone the latest tag
git clone --depth 1 --branch $LATEST_TAG $REPO
