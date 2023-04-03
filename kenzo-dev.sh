#!/usr/bin/env bash

### configuration
export PROJECT_ID=grp-dev-kenzo-prj-clienteling
export CLUSTER_NAME=clienteling-kenzo-dev
export CLUSTER_LOCATION=europe-west4-a
export BASTION_NAME=bastion-proxy
export BASTION_LOCATION=europe-west4-a
# This port will be opened on your laptop and it should be uniq if you want to connect to several cluster(s)
export STATIC_PORT=8888
# We are defining a more explicit context name
export CONTEXT_NAME=kenzo-dev
export GCP_NAMESAPCE=clienteling-backend
export ELASTIC_POD=es-product-catalog-es-default-0
### main script
SCRIPT_SOURCE="."
if [ -n "${ZSH_VERSION}" ]; then
   SCRIPT_SOURCE=${(%):-%x}
elif [ -n "${BASH_VERSION}" ]; then
   SCRIPT_SOURCE=${BASH_SOURCE[0]}
fi
   echo $SCRIPT_SOURCE
__dir="$(cd "$(dirname "${SCRIPT_SOURCE}")" && pwd)"
source ${__dir}/bastion.sh
