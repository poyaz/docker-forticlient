#!/usr/bin/env bash

DIRNAME=$(realpath "$0" | rev | cut -d'/' -f2- | rev)
readonly DIRNAME

if ! command -v yq &> /dev/null
then
    echo "Please install 'yq' in your operation system"
    exit 1
fi

prefix_image_forti="poyaz/forticlient"
prefix_image_ssh="poyaz/forticlient-ssh"

forti_version=$(yq -r '.version.forticlient' .config.yaml)
ssh_version=$(yq -r '.version.ssh' .config.yaml)

cd "${DIRNAME}/docker/images/forticlient" || exit 1
docker build -t "${prefix_image_forti}:${forti_version}" .
docker build -t "${prefix_image_forti}:latest" .

cd "${DIRNAME}/docker/images/ssh" || exit 1
docker build -t "${prefix_image_ssh}:${ssh_version}" .
docker build -t "${prefix_image_ssh}:latest" .

cd "${DIRNAME}" || exit 1

docker push "${prefix_image_forti}:${forti_version}" .
docker push "${prefix_image_forti}:latest"

docker push "${prefix_image_ssh}:${ssh_version}" .
docker push "${prefix_image_ssh}:latest"
