
output "workspace_name" {
   description = "Terraform workspace name:"
   value = "${tfe_workspace.ws.*.name}"
}

output "workspace_id" {
   description = "Terraform workspace id:"
   value = "${tfe_workspace.ws.*.id}"
}

output "proj_team_name" {
   description = "proj_team_name:"
   value = "${tfe_team.proj.name}"
}

output "admin_team_name" {
   description = "admin_team_name:"
   value = "${tfe_team.admin.name}"
}

output "resource_group_names" {
   description = "resource_group_names:"
   value = "${azurerm_resource_group.rg.*.name}"
}

 output "team_token" {
    description = "team_token:"
    value = "${tfe_team_token.tk.token}"
}

// output "spn_id" {
//    description = "spn_id"
//    value = "${azuread_service_principal.spn.id}"
// }