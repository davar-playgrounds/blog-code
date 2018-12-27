# Provider
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "region" {}
variable "private_key_path" {}
variable "private_key_password" {}
# Infrastructure
variable "vcn_cidr" { type = "string" default = "10.1.0.0/18" }
