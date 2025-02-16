variable "environment" {  
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc-ny"
}
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/23"
}