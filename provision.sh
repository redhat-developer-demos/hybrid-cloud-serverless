#!/usr/bin/env bash

set -e

_CURR_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
_K8S_AUTH_KUBECONFIG=$1

if [ -z "$_K8S_AUTH_KUBECONFIG" ];
then
  echo "Please specify the KUBECONFIG to use";
  exit 1;
fi

docker run -it  \
 -v ${_CURR_DIR}/env:/runner/env:Z \
 -v ${_CURR_DIR}/project:/runner/project:Z \
 -v ${_K8S_AUTH_KUBECONFIG}:/runner/kubeconfig:Z \
 --env-file .env \
  ansible/ansible-runner:latest /runner/project/run.sh