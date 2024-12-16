// create vpc for eks cluster

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.13.0"
    name = "eks-vpc"
    cidr = var.vpc_cidr_block

    azs                = data.aws_availability_zones.azs.names
    public_subnets     = var.public_subnets
    private_subnets    = var.private_subnets
    enable_dns_support = true
    enable_dns_hostnames = true
    enable_nat_gateway = true
    single_nat_gateway = true
    map_public_ip_on_launch = true
    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        
    }
    public_subnet_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        kubernetes.io/role/elb = 1
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        kubernetes.io/role/internal-elb = 1
    }
    
}

// create eks cluster module

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"
    cluster_name = var.cluster_name
    cluster_version = "1.30"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    cluster_endpoint_public_access = true

    eks_managed_node_groups = {
        node_group = {
            min_size = var.node_group_min_size
            max_size = var.node_group_max_size
            desired_size = var.node_group_desired_size
            instance_types = [var.node_group_instance_type]
        }
    }
}

// create iam role for eks to allow kubernetes to manage resource


resource "aws_iam_role" "eks" {
    name = "eks"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "eks.amazonaws.com"
                }
            }
        ]
    })
}
// create iam role for ec2 to allow eks to manage resource
resource "aws_iam_role" "ec2" {
    name = "ec2"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}
# iam role policy for eks
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks.name
}
# create iam role policy attachment for eks
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.eks.name
}
#aws cni policy
resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.eks.name
}
#aws eks worker node policy
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks.name
}
#aws ec2 container registry
resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.eks.name
}
// oidc provider
#aws configure

// create kubernetes configmap for eks

resource "aws_eks_cluster" "eks" {
    name     = var.cluster_name
    role_arn = aws_iam_role.eks.arn

    vpc_config {
        subnet_ids = module.vpc.private_subnets
        public_access_cidrs = ["0.0.0.0/0"]
    }
}


//iam role for eks service account



#to connect eks to kubernetes cluster
#aws eks --region us-east-1 update-kubeconfig --name cluster-name
#openID connect provider for eks
#eksctl utils associate-iam-oidc-provider --region us-east-1--cluster-name cluster-name --approve
