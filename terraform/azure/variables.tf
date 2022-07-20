variable "ARM_SUBSCRIPTION_ID" {
  description = "subscription to deploy resources to"
}

variable "ARM_CLIENT_ID" {
  description = "service principal client id"
}

variable "ARM_CLIENT_SECRET" {
  description = "service principal client secret"
}

variable "ARM_TENANT_ID" {
  description = "azure tenant id"
}

variable "location" {
  description = "The region where the resources are created"
  default     = "East US 2"
}

variable "ADMIN_USERNAME" {
  description = "vm username"
}

variable "ADMIN_PASSWORD" {
  description = "vm password"
}