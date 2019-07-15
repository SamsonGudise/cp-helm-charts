1. **Install Instructions**
    ```
    $ cd config
    $ ./create-configmap-secret.sh 
    secret/connect-distributed-config created
    configmap/connect-log4j-config created
    $ 
    $ cd ..
    $ kubectl apply -f kafka-connect.yaml 
    deployment.apps/kafkaconnect-deploy created
    service/kafkaconnect-service created
    $
    ```
1. **Test**
    ```
    kubectl exec -it kafka-client -n confluent /bin/bash
    root@kafka-client:/# 

    root@kafka-client:/# curl kafkaconnect-service:8083/connector-plugins
    [{"class":"com.ibm.eventstreams.connect.mqsource.MQSourceConnector","type":"source","version":"1.1.0"},{"class":"org.apache.kafka.connect.file.FileStreamSinkConnector","type":"sink","version":"2.2.0"},{"class":"org.apache.kafka.connect.file.FileStreamSourceConnector","type":"source","version":"2.2.0"}]root@kafka-client:/#
    ```
    ```
    root@kafka-client:/# curl http://kafkaconnect-service:8083/connectors
    []root@kafka-client:/# 
    ```


1. **Create MQ Connector config**
    ```
    root@kafka-client:/# cat << EOF > mqconnector.json
    > {
    >   "name": "mqconnector",
    >   "config": {
    >       "connector.class": "com.ibm.eventstreams.connect.mqsource.MQSourceConnector",
    >       "kafka.topic":"bm-bsm-in",
    >       "mq.hostname":"ipaddres(port)",
    >       "mq.transport.type":"client",
    >       "mq.queue.manager":"QMANGER",
    >       "mq.channel":"QMANGER.SVRCONN.1",
    >       "jms.destination.name":"ua-mqconnector-test",
    >       "confluent.license":"",
    >       "confluent.topic.bootstrap.servers":"demo-cp-kafka-headless:9092",
    >       "mq.queue":"MQ:ABC.OPS.TST.XYZ.BXG.AB.1",
    >       "mq.record.builder":"ab-abc-in",
    >       "topic":"ab-abc-in"
    >   }
    > }
    > EOF
    root@kafka-client:/#
    ```
1. **Check status and content of file**
    ```
    root@kafka-client:/# ls -l mqconnector.json 
    -rw-r--r-- 1 root root 590 Jul 15 20:52 mqconnector.json
    root@kafka-client:/# 
    ```
1. **Create MQ Connector**
    ```
    root@kafka-client:/# curl -s -X POST -H 'Content-Type: application/json' --data @mqconnector.json http://kafkaconnect-service:8083/connectors
    .
    .
    .
    root@kafka-client:/# 
    ```
1. **List all connectors**
    ```
    root@kafka-client:/# curl http://kafkaconnect-service:8083/connectors
    ["mqconnector"]root@kafka-client:/# 
    ```
