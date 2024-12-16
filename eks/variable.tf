variable "vpc_cidr_block" {
    default = "vpc_cidr_block"
    type    = string
}
variable "private_subnets" {
    type    = list(string)
    default = ["subnet1", "subnet2", "subnet3"]
}
variable "public_subnets" {
    type    = list(string)
    default = ["subnet4", "subnet5", "subnet6"]
}
variable "cluster_name" {
    default = "cluster_name"
    type    = string
}
variable "node_group_name" {
    default = "node_group_name"
    type    = string
}
variable "node_group_instance_type" {
    default = "node_group_instance_type"
    type    = string
}
variable "node_group_min_size" {
    type    = number
}
variable "node_group_max_size" {
    type    = number
}
variable "node_group_desired_size" {
    type    = number
}
