variable "vinted_vnet_name" {
  type    = string
  default = "vinted-network"
}
variable "vinted_rg_name" {
  type    = string
  default = "vinted-rg"
}
variable "vinted_rg_location" {
  type    = string
  default = "northeurope"
}
variable "vinted_vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the Virtual Network"
}
variable "vinted_subnet_address_space" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "Address space for the Virtual Network"
}
variable "vinted_public_ip_name" {
  type    = string
  default = "vinted_public_ip"
}
variable "vinted_nic_name" {
  type    = string
  default = "vinted-app-oicd-nic"
}
variable "vinted_nsg_name" {
  type    = string
  default = "vinted-oicd-app-nsg"
}
variable "vinted_oicd_app_vm_name" {
  type    = string
  default = "vinted-oicd-app-vm"
}
variable "vinted_oicd_app_vm_size" {
  type    = string
  default = "Standard_B1s"
}
variable "vinted_oicd_app_vm_admin_username" {
  type    = string
  default = "adminuser"
}
# OS Disk Variables
variable "vinted_oicd_app_vm_os_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "The caching mode for the OS disk"
}

variable "vinted_oicd_app_vm_os_disk_storage_account_type" {
  type        = string
  default     = "Standard_LRS"
  description = "The storage account type for the OS disk"
}

# Source Image Reference Variables
variable "vinted_oicd_app_vm_image_publisher" {
  type        = string
  default     = "Canonical"
  description = "The publisher of the source image"
}

variable "vinted_oicd_app_vm_image_offer" {
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
  description = "The offer of the source image"
}

variable "vinted_oicd_app_vm_image_sku" {
  type        = string
  default     = "22_04-lts"
  description = "The SKU of the source image"
}

variable "vinted_oicd_app_vm_image_version" {
  type        = string
  default     = "latest"
  description = "The version of the source image"
}

variable "vinted_oicd_app_vm_admin_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the public SSH key to be used for the admin user"
}
variable "vinted_tags" {
  type        = map(string)
  description = "A map of tags to assign to resources"
  default = {
    App         = "Test"
    Environment = "tryout"
    Owner       = "laurynas.jonusas"
  }
}
variable "azurerm_subscription_id" {
  type        = string
  default     = "107d9e92-c72b-4e37-92c4-b32a93bacdcb"
}

variable "vinted_container_registry_name" {
  type        = string
  default     = "vintedContainerRegistry"
}