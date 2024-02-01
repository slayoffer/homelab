terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "registry.example.com/telmate/proxmox" # will need to update this later
      version = ">= 1.0.0"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.1.109:8006/api2/json"
    pm_api_token_secret = var.pm_api_token_secret
    pm_api_token_id = "root@pam!terraform"
}