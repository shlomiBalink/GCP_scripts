#!/bin/bash

# Open a new terminal in WSL
start bash.exe
export GCP_NAMESAPCE=clienteling-backend
export ELASTIC_POD=es-product-catalog-es-default-0

kibana_pod=$(kubectl get pods -n $GCP_NAMESAPCE --selector='common.k8s.elastic.co/type=kibana' -o name)
kubectl port-forward -n $GCP_NAMESAPCE $kibana_pod 5601

