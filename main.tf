
provider "aws" {
  alias   = "eu-west"
  profile = "default"
  region  = "eu-west-1"  
}

module "vpc1" {
  source   = "./vpc"
  providers = {
    aws = aws.eu-west
  }
  vpc_cidr = local.vpc_cidr
  #number of subnet to generate using cidrsubnet function  
  public_sn_count = 2
  max_subnets     = 20
  access_ip       = var.access_ip
  security_groups = local.security_groups
  #for loop to generate subnet numbers using cidrsubnet function 
  public_cidrs = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

provider "aws" {
  alias   = "eu-north"
  profile = "default"
  region  = "eu-north-1"  
}

module "vpc2" {
  source   = "./vpc"
  providers = {
    aws = aws.eu-north
  }
  vpc_cidr = local.vpc_cidr2
  #number of subnet to generate using cidrsubnet function  
  public_sn_count = 2
  max_subnets     = 20
  access_ip       = var.access_ip
  security_groups = local.security_groups
  #for loop to generate subnet numbers using cidrsubnet function 
  public_cidrs = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr2, 8, i)]
}

# module "compute" {
#   source          = "./compute"
#   public_sg       = module.vpc1.public_sg
#   public_subnets  = module.vpc1.public_subnets
#   instance_count  = 2
#   instance_type   = "t2.micro"
#   public_key_path = var.public_key_path
#   key_name        = "trkey"
# }

module "eks" {
  source          = "./eks"
  vpc_id          = [module.vpc1.vpc_id, module.vpc2.vpc_id]
  public_subnets  = concat(module.vpc1.public_subnets, module.vpc2.public_subnets)
  public_sg       = module.vpc1.public_sg
  public_key_path = var.public_key_path
  cluster_count   = 2
}
