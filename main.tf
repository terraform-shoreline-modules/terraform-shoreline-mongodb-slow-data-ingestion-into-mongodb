terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "slow_data_ingestion_into_mongodb" {
  source    = "./modules/slow_data_ingestion_into_mongodb"

  providers = {
    shoreline = shoreline
  }
}