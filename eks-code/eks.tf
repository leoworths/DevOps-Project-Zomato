module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name}"
  cluster_version = "1.31"

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  create_cluster_security_group = false
  create_node_security_group = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    zomato-node = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.large"]
      volume_size    = 30
      min_size = 1
      max_size = 2
      desired_size = 1
    }
  }
  tags = local.tags
  depends_on = [module.vpc]
}