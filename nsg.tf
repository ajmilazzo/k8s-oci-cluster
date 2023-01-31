resource "oci_core_network_security_group" "public_lb_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default_oci_core_vcn.id
  display_name   = "K8s public LB nsg"

  freeform_tags = local.tags
}

resource "oci_core_network_security_group_security_rule" "allow_http_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTP from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = var.http_lb_port
      min = var.http_lb_port
    }
  }

}

resource "oci_core_network_security_group_security_rule" "allow_https_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTPS from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = var.https_lb_port
      min = var.https_lb_port
    }
  }
}

# resource "oci_core_network_security_group_security_rule" "kubeapi" {
#   network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
#   direction                 = "INGRESS"
#   protocol                  = 6 # tcp

#   description = "kubeapi rule"

#   source      = var.my_public_ip_cidr
#   source_type = "CIDR_BLOCK"
#   stateless   = false

#   tcp_options {
#     destination_port_range {
#       max = 6443
#       min = 6443
#     }
#   }
# }