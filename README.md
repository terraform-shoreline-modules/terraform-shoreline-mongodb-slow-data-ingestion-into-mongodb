
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Slow Data Ingestion into MongoDB
---

This incident type refers to a situation where there is a significant delay in the process of importing or uploading data into a MongoDB database. This delay could be caused by various factors, such as network issues, performance problems with the application or the database, or data formatting errors. Slow data ingestion can lead to a backlog of data that needs to be processed, resulting in data loss or reduced system efficiency. As a result, it is critical to identify the underlying cause of this issue and address it as soon as possible to ensure efficient data management and processing.

### Parameters
```shell
export MONGODB_SERVER_IP="PLACEHOLDER"

export MONGODB_PORT="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"

export MONGO_CONFIG_FILE_PATH="PLACEHOLDER"

export REPLICA_SET_NAME="PLACEHOLDER"

export OPLOG_SIZE="PLACEHOLDER"
```

## Debug

### Check MongoDB server status
```shell
sudo systemctl status mongod
```

### Check MongoDB server logs
```shell
sudo tail -f /var/log/mongodb/mongod.log
```

### Check MongoDB database status
```shell
mongo --host ${MONGODB_SERVER_IP} --port ${MONGODB_PORT} --eval "db.runCommand({ serverStatus: 1 })"
```

### Check MongoDB database indexes
```shell
mongo --host ${MONGODB_SERVER_IP} --port ${MONGODB_PORT} --eval "db.${DATABASE_NAME}.getIndexes()"
```

### Check MongoDB database storage statistics
```shell
mongo --host ${MONGODB_SERVER_IP} --port ${MONGODB_PORT} --eval "db.stats()"
```

### Check MongoDB database queries
```shell
mongo --host ${MONGODB_SERVER_IP} --port ${MONGODB_PORT} --eval "db.${DATABASE_NAME}.find().limit(10)"
```

### Check MongoDB database slow queries
```shell
mongo --host ${MONGODB_SERVER_IP} --port ${MONGODB_PORT} --eval "db.currentOp({ 'millis': { '$gt': 100 } })"
```

### Check MongoDB database fragmentation
```shell
mongo --host ${MONGODB_SERVER_IP} --port ${MONGODB_PORT} --eval "db.${COLLECTION_NAME}.stats()"
```

## Repair

### Tune the MongoDB configuration settings to optimize performance for data ingestion workload.
```shell


#!/bin/bash



# Define variables

MONGO_CONFIG_FILE=${MONGO_CONFIG_FILE_PATH}



# Update the MongoDB configuration file with the optimized settings

sudo sed -i 's/#operationProfiling:/operationProfiling:/g' $MONGO_CONFIG_FILE

sudo sed -i 's/#    slowOpThresholdMs: 100/slowOpThresholdMs: 50/g' $MONGO_CONFIG_FILE

sudo sed -i 's/#    mode: slowOp/mode: slowOp/g' $MONGO_CONFIG_FILE

sudo sed -i 's/#replication:/replication:/g' $MONGO_CONFIG_FILE

sudo sed -i 's/#    replSetName: ${REPLICA_SET_NAME}/replSetName: rs0/g' $MONGO_CONFIG_FILE

sudo sed -i 's/#    oplogSizeMB: ${OPLOG_SIZE}/oplogSizeMB: 1024/g' $MONGO_CONFIG_FILE

sudo sed -i 's/#    enableMajorityReadConcern: false/enableMajorityReadConcern: true/g' $MONGO_CONFIG_FILE



# Restart the MongoDB service to apply the changes

sudo service mongodb restart


```