#Required Variables

variable "ENV_ID" {
  type = "string"
  description = "(Required) Provide the ENVIRONMENT_ID"
}
variable "TFE_ORG" {
  type = "string"
  description = "(Required) Provide TFE_ORG"
}

variable "TFE_TEAM_MEMBERS" {
  type        = "list"
  description = "(Required) Provide the TFE_TEAM_MEMBERS"
}

variable "TFE_URL" {
  type = "string"
  description = "(Required) Provide TFE_URL"
}

variable "RESOURCE_GROUPS" {
  type        = "list"
  description = "(Required) Provide RESOURCE_GROUP details:"
}

variable "SUBSCRIPTION_ID" {
  type = "string"
  description = "(Required) Provide SUBSCRIPTION_ID:"
}

variable "CLIENT_ID" {
  type = "string"
  description = "(Required) Provide CLIENT_ID:"
}

variable "CLIENT_SECRET" {
  type = "string"
  description = "(Required) Provide CLIENT_SECRET:"
}

variable "TENANT_ID" {
  type = "string"
  description = "(Required) Provide TENANT_ID:"
}

variable "WORKSPACES" {
  type = "list"
  description = "(Required) List of workspaces that need to be created."
  # default = [
  #   {
  #     purpose = ""
  #   }
  # ]
}

variable "TAGS" {
  description = "(Required) Provide TAGS"
  type        = "map"
  default = {}  
}

variable "ENV_TYPE"{
  description = "(Required) Provide Environment Type:"
}

#Local Variables
locals {
    RG_COUNT = "${var.ENV_TYPE=="AURA"?0:length(var.RESOURCE_GROUPS)}"
 }