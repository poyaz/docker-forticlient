#!/usr/bin/env bash

DIRNAME=$(realpath $0 | rev | cut -d'/' -f2- | rev)
readonly DIRNAME

cd "${DIRNAME}/docker/images/forticlient"
docker build -t poyaz/forticlient:latest .

cd "${DIRNAME}/docker/images/ssh"
docker build -t poyaz/forticlient-ssh:latest .

cd "${DIRNAME}"

docker push poyaz/forticlient:latest
docker push poyaz/forticlient-ssh:latest
