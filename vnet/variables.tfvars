vnet_name = "Looyas-Vnet"

resource_group_name = "Looyas_Rg"

use_for_each = true

vnet_location = "EAST US2"

address_space = ["10.0.0.0/16"]

subnet_names = ["Subnet_1","Subnet_2"]

subnet_prefixes = ["10.0.1.0/24","10.0.2.0/24"]

nsg_ids ={ 
	Subnet_1 = "nsg-123456"
	Subnet_2 = "nsg-789012"
}

route_tables_ids ={ 
	Subnet_1 = "rt1-id"
	Subnet_2 = "rt2-id"
}

subnet_service_endpoints = { 
    Subnet_1 = ["Microsoft.Storage","Microsoft.KeyVault"]
    Subnet_2 = ["Microsoft.Storage"]
}

tags = { 
	Env = "Prod"
	Dept = "IT"
}