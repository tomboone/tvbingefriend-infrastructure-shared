# Corresponds to secrets.TF_STATE_RG
resource_group_name  = "rg-tvbingefriend-tfstate"

# Corresponds to secrets.TF_STATE_SA
storage_account_name = "terraformstatetvbfsa"

# These are static in your workflow
container_name       = "tfstate"
key                  = "tvbfshared.tfstate"
