#!/bin/bash
kubectl -n confluent create secret generic connect-distributed-config --from-file=connect-distributed.properties
kubectl -n confluent create configmap connect-log4j-config --from-file=connect-log4j.properties