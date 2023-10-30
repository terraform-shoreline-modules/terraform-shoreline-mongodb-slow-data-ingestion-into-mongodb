

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