[![Build Status](https://dev.azure.com/pwc-gx-nis/NextGen%20Cloud/_apis/build/status/NextGen-Create-App-Environment-CI?branchName=master)](https://dev.azure.com/pwc-gx-nis/NextGen%20Cloud/_build/latest?definitionId=10&branchName=master)
# terraform-azure-cloud-environment
This module creates basic infrastructure required for azure environment like TFE workspaces, Azure Resource Groups, SPNs etc.
### Mandatory input variables
| Name              | Type        | Description |
| ------------------| ----------- | -------------------------------------------------------------------------------------- | 
| ENV_ID | String | Unique environment id code|
| TFE_ORG        | String | TFE Organization where workspace will be created|
| TFE_TEAM_MEMBERS        | String | All team memebers to be included in the team|
| TFE_URL        | String | url of the TFE|
| TAGS        | Map | tags to be used for resource groups created for this environment|
| RESOURCE_GROUPS        | List | List of resource groups to be created|
| SUBSCRIPTION_ID        | String | Subscription Id where resource groups to be created |
| CLIENT_ID        | String | Client Id |
| CLIENT_SECRET        | String | Client secret to be used|
| TENANT_ID        | String | Tenant Id|
| SPN_PASSWORD | String | Password to be set as client_secret for SPN created |
| ENTERPRISE_APP_NAME | String | Name for the Enterprise Application/App Registration(SPN) created |

### Optional input variables
| Name              | Type        | Description |
| ------------------| ----------- | -------------------------------------------------------------------------------------- | 
| WS_COUNT | String | Number of workspaces to be created. Default value is 1. |


### Usage:
NOTE - All sensative varilable must be vaulted or supplied. Please do not provide/checkin in the code.

The following example demonstrate how to use this module:

```hcl
module "cloud_env" {
    # Absolute path to the module source.
    source = ".terraform-azurerm-cloud-environment"
    version = "version#"
    
    # Mandatory variables.
    ENVIRONMENT_ID = "testid"
    TFE_ORG = "orgname"
    TFE_URL = "https://tfeurl"
    RESOURCE_GROUPS =  [
            {
                name     = "standardnameone"
                location = "eastus"
            },
            {
                name     = "standardnametwo"
                location = "westus"
            }
        ]
    TFE_TEAM_MEMBERS = []
    SUBSCRIPTION_ID = "${var.inputvariable}"
    CLIENT_ID = "${var.inputvariable}"
    CLIENT_SECRET = "${var.inputvariable}"
    TENANT_ID = "${var.inputvariable}"
    ENTERPRISE_APP_NAME = "${var.inputvariable}"
    SPN_PASSWORD = "${var.inputvariable}"
    TAGS = {
        ghs-appid = ""
        ghs-billingterritory = ""
        ghs-apptioid=""
        ghs-envid=""
        ghs-los="IFS"
        ghs-owner=""
        ghs-solution=""
    }
}
```

### Output variables
| Name                      | Type    |  Description                                                        |
| ------------------------- | ------- | --------------------------------------------------------------------| 
| workspace_name | String  | workpsace name|
| workspace_id| String  | workspace id created|
| team_name| String  | name of the created TFE team |
| resource_group_names       | List  | Names of the resource groups created for this environment |
| spn_id       | String  | ID for the service princpial created to manage RGs |




