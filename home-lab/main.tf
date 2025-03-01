#add VLAN
resource "panos_vlan" "vlan5" {
    name = "TEST"
    vlan_interface = panos_vlan_interface.vli.name 
    lifecycle {
        create_before_destroy = true
    }
}

#Creating vlan interface
resource "panos_vlan_interface" "vli" {
    name = "vlan.5"
    vsys = "vsys1"    
    static_ips = ["10.1.1.1/24"]
    comment = "Configured for internal traffic"    
    management_profile = "mgmt"  
 
}
#createing zone TEST
resource "panos_zone" "TEST" {
    name = "TEST"
    mode = "layer3"
    
    lifecycle {
        create_before_destroy = true
    }
}
#adding vlan.5 to zone
resource "panos_zone_entry" "example" {
    zone = panos_zone.TEST.name
    interface = "vlan.5"
    lifecycle {
        create_before_destroy = true
    }
}
#add an interface in a VLAN on Panorama.
resource "panos_vlan_entry" "example" {
    vlan = panos_vlan.vlan5.name
    interface = panos_layer2_subinterface.example.name
    lifecycle {
        create_before_destroy = true
    }
}

#adding l2 subinterface to aggregate interface
resource "panos_layer2_subinterface" "example" {
    parent_interface = "ae4"
    interface_type = "aggregate-ethernet"
    parent_mode = "layer2"
    vsys = "vsys1"
    name = "ae4.5"
    tag = 5
}

#adding vlan to virtual router
resource "panos_virtual_router_entry" "default" {
    virtual_router = "default"
    interface = panos_vlan_interface.vli.name

    lifecycle {
        create_before_destroy = true
    }
}
# Creating all ethernet interfaces
module "interfaces" {
  source  = "../modules/interfaces"

  mode = "ngfw" # If you want to use this module with a firewall, change this to "ngfw"

  template = "test"
  
  interfaces = { 
    "ae4" ={
    type = "aggregate"    
    name = "ae4"
    mode = "layer2"
    comment = "AE Group"
    lacp_enable = true
    }    
    "ethernet1/3" = {
      type                      = "ethernet"
      mode                      = "aggregate-group"
    #  management_profile        = "mgmt"
      link_state                = "up"
      enable_dhcp               = false
      create_dhcp_default_route = false
      #comment                   = "mgmt"
      #virtual_router            = "default"
      #zone                      = "mgmt"      
      aggregate_group           = "ae4"
    }
    "ethernet1/4" = {
      type               = "ethernet"
      mode               = "aggregate-group"
    #  management_profile = "mgmt"
      link_state         = "up"
      enable_dhcp        = false
    #   comment            = "external"
    #   virtual_router     = "external"
    #   zone               = "external"     
      aggregate_group    = "ae4"
    }   
  }
}
