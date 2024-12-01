vpc_cidr_block = "192.168.0.0/16"
private_subnets = [ "192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"] # 3 subnets for 3 AZs
public_subnets = [ "192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"] # 3 subnets for 3 AZs
node_group_name = "zomato-node-group"
cluster_name = "zomato-cluster"
node_group_instance_type = "t2.medium"
node_group_min_size = 1
node_group_max_size = 2
node_group_desired_size = 1
