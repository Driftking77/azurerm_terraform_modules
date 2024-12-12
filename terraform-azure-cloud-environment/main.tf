/* partial backend config needs to be provided during init - storage_account_name, key & access_key 
*/

terraform {
  backend "azurerm" {
    container_name = "terraform-state"
  }
}

#Providers 
provider "tfe" {
  version = "<= 0.7.0"
  hostname = "${var.TFE_URL}"
}

// provider "azuread" {
//   # Needs to have 'Read and write all applications' and 'Sign in and read user profile' to manage SPNs
//   subscription_id = "${var.SUBSCRIPTION_ID}"
//   client_id       = "${var.CLIENT_ID}"
//   client_secret   = "${var.CLIENT_SECRET}"
//   tenant_id       = "${var.TENANT_ID}"
// }

provider "azurerm" {
  /* these credentials needs contributor rights on the subscription */
  subscription_id = "${var.SUBSCRIPTION_ID}"
  client_id       = "${var.CLIENT_ID}"
  client_secret   = "${var.CLIENT_SECRET}"
  tenant_id       = "${var.TENANT_ID}"
}

# Resources

resource "tfe_team" "proj" {
  name         = "${lower(var.TFE_ORG)}-azure-${lower(var.ENV_ID)}-team-proj"
  organization = "${var.TFE_ORG}"
}

resource "tfe_team" "admin" {
  name         = "${lower(var.TFE_ORG)}-azure-${lower(var.ENV_ID)}-team-admin"
  organization = "${var.TFE_ORG}"
}

resource "tfe_workspace" "ws" {
  name           = "${lower(var.TFE_ORG)}-azure-${lower(var.ENV_ID)}-wksp-${lookup(var.WORKSPACES[count.index], "purpose")}"
  organization   = "${var.TFE_ORG}"
  queue_all_runs = "false"
  count          = "${length(var.WORKSPACES)}"
}

resource "tfe_team_access" "teamaccess" {
  access       = "admin"
  team_id      = "${tfe_team.admin.id}"
  workspace_id = "${tfe_workspace.ws.*.id[count.index]}"
  count        = "${length(var.WORKSPACES)}"
  depends_on = ["tfe_team.admin"]
}

resource "tfe_team_access" "teamaccessproj" {
  access       = "read"
  team_id      = "${tfe_team.proj.id}"
  workspace_id = "${tfe_workspace.ws.*.id[count.index]}"
  count        = "${length(var.WORKSPACES)}"
}

resource "tfe_team_members" "members" {
  team_id   = "${tfe_team.proj.id}"
  usernames = "${var.TFE_TEAM_MEMBERS}"
}

resource "tfe_team_token" "tk" {
  team_id = "${tfe_team.admin.id}"
  depends_on = ["tfe_team_access.teamaccess"]
}

resource "azurerm_resource_group" "rg" {
  name     = "${lookup(var.RESOURCE_GROUPS[count.index], "name")}"
  location = "${lookup(var.RESOURCE_GROUPS[count.index], "location")}"
  count    = "${local.RG_COUNT}"
  tags = "${var.TAGS}"
}

// resource "tfe_variable" "cid" {
//   key          = "ARM_CLIENT_ID"
//   value        = "${var.CLIENT_ID}"
//   category     = "env"
//   sensitive    = false
//   workspace_id = "${tfe_workspace.test.*.id[count.index]}"
//   count        = "${var.WS_COUNT}"
// }

// resource "tfe_variable" "key" {
//   key          = "ARM_CLIENT_SECRET"
//   value        = "${var.CLIENT_SECRET}"
//   category     = "env"
//   sensitive    = true
//   workspace_id = "${tfe_workspace.test.*.id[count.index]}"
//   count        = "${var.WS_COUNT}"
// }

// resource "tfe_variable" "tenant" {
//   key          = "ARM_TENANT_ID"
//   value        = "${var.TENANT_ID}"
//   sensitive    = false
//   category     = "env"
//   workspace_id = "${tfe_workspace.test.*.id[count.index]}"
//   count        = "${var.WS_COUNT}"
// }

// resource "tfe_variable" "sub" {
//   sensitive    = false
//   key          = "ARM_SUBSCRIPTION_ID"
//   value        = "${var.SUBSCRIPTION_ID}"
//   category     = "env"
//   workspace_id = "${tfe_workspace.test.*.id[count.index]}"
//   count        = "${var.WS_COUNT}"
// }

// resource "azuread_application" "entapp" {
//   name                       = "${var.ENTERPRISE_APP_NAME}"
//   homepage                   = "https://homepage"
//   identifier_uris            = ["http://uri"]
//   reply_urls                 = ["http://replyurl"]
//   available_to_other_tenants = false
//   oauth2_allow_implicit_flow = true
//   count                = "${length(var.RESOURCE_GROUPS)>0?1:0}"
// }

// resource "azuread_service_principal" "spn" {
//   application_id = "${azuread_application.entapp.application_id}"
//   count                = "${length(var.RESOURCE_GROUPS)>0?1:0}"
// }

// resource "azuread_service_principal_password" "spnpw" {
//   count                = "${length(var.RESOURCE_GROUPS)>0?1:0}"
//   service_principal_id = "${azuread_service_principal.spn.id}"
//   value                = "${var.SPN_PASSWORD}"
//   end_date             = "2120-01-01T01:02:03Z"
// }

// resource "azurerm_role_assignment" "role" {
//   count                = "${length(var.RESOURCE_GROUPS)}"
//   scope                = "${element(azurerm_resource_group.rg.*.id, count.index)}"
//   role_definition_name = "Contributor"
//   # SPN needs to have owner rights to be able to provide contributor on Resource Group
//   principal_id         = "${azuread_service_principal.spn.id}"
// }