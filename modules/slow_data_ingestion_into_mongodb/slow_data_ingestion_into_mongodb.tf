resource "shoreline_notebook" "slow_data_ingestion_into_mongodb" {
  name       = "slow_data_ingestion_into_mongodb"
  data       = file("${path.module}/data/slow_data_ingestion_into_mongodb.json")
  depends_on = [shoreline_action.invoke_mongo_config_update]
}

resource "shoreline_file" "mongo_config_update" {
  name             = "mongo_config_update"
  input_file       = "${path.module}/data/mongo_config_update.sh"
  md5              = filemd5("${path.module}/data/mongo_config_update.sh")
  description      = "Tune the MongoDB configuration settings to optimize performance for data ingestion workload."
  destination_path = "/tmp/mongo_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mongo_config_update" {
  name        = "invoke_mongo_config_update"
  description = "Tune the MongoDB configuration settings to optimize performance for data ingestion workload."
  command     = "`chmod +x /tmp/mongo_config_update.sh && /tmp/mongo_config_update.sh`"
  params      = ["MONGO_CONFIG_FILE_PATH","REPLICA_SET_NAME","OPLOG_SIZE"]
  file_deps   = ["mongo_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.mongo_config_update]
}

