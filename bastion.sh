#!/usr/bin/env bash
set -e

missing_var=

if [ -z $STATIC_PORT ];
then
    echo STATIC_PORT env var is needed
    missing_var=1
fi

if [ -z $BASTION_NAME ];
then
    echo BASTION_NAME env var is needed
    missing_var=1
fi

if [ -z $BASTION_LOCATION ];
then
    echo BASTION_LOCATION env var is needed
    missing_var=1
fi

if [ -z $PROJECT_ID ];
then
    echo PROJECT_ID env var is needed
    missing_var=1
fi

if [ -z $CLUSTER_NAME ];
then
    echo CLUSTER_NAME env var is needed
    missing_var=1
fi

if [ -z $CLUSTER_LOCATION ];
then
    echo CLUSTER_LOCATION env var is needed
    missing_var=1
fi

if [ -z $CONTEXT_NAME ];
then
    echo CONTEXT_NAME env var is needed
    missing_var=1
fi

if [ ! -z $missing_var ];
then
    exit 1
fi

# Open a SSH tunnel to the jumphost (Bastion)
# Kill previously opened tunnel if any


ps aux | grep ssh | grep "$STATIC_PORT" | awk "{print \$2}"
gcloud compute ssh $BASTION_NAME \
  --zone $BASTION_LOCATION \
  --project $PROJECT_ID \
  -- -L$STATIC_PORT:127.0.0.1:8888 -N -q -f

# If you want to check if the port(s) are opened
# lsof -i -P | grep -i "listen"

# Get kubeconfig from gcloud
gcloud container clusters get-credentials $CLUSTER_NAME \
  --zone $CLUSTER_LOCATION \
  --project $PROJECT_ID

# Change the name of the context

kubectl config get-contexts


CURRENT_CONTEXT=$(kubectl config view --minify -o jsonpath='{.clusters[].name}') 
kubectl config set-context $CONTEXT_NAME=$CURRENT_CONTEXT

# Proxy Configuration kubeconfig
kubectl config set clusters.${CURRENT_CONTEXT}.proxy-url http://localhost:$STATIC_PORT
kubectl port-forward  -n $GCP_NAMESAPCE $ELASTIC_POD 9200


bash -c "bash --login"

kibana_pod=$(kubectl get pods -n $GCP_NAMESAPCE --selector='common.k8s.elastic.co/type=kibana' -o name)
kubectl port-forward -n $GCP_NAMESAPCE $kibana_pod 5601