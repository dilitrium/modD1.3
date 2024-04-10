terraform {
  # Используемая версия Terraform в проекте
  required_version = "1.5.5"
  required_providers {
    yandex = {
      source                = "yandex-cloud/yandex"
      version               = "0.100.0" 
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "sf-bucket-beridium"
    region     = "ru-central1-a"
    key        = "sfstate/swarm.tfstate"
    access_key = "YCAJESToi_GSxIAkktKGo8ODI"
    secret_key = "YCOtG0_NJ0Tgehwnzjc5RIjnk4eLPRT6_8Fx_Gol"

    skip_region_validation      = true
    skip_credentials_validation = true
    #   skip_requesting_account_id  = true
    #   skip_metadata_api_check     = true
  }
}

provider "yandex" {
  token = "y0_AgAAAAByMlwJAATuwQAAAADzoD1RXmKxHLWaStSQsYKFNndskOeCh_M"
  # service_account_key_file = file("~/authorized_key.json")
  cloud_id  = "b1g7htbt15eptelpg2hg"
  folder_id = "b1gsn7asivb4355ot1ju"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet-sw" {
  name           = "subnet-sw"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source                = "./modules/instance"
  vpc_subnet_id         = yandex_vpc_subnet.subnet-sw.id
  managers               = 1
  workers               = 2
}