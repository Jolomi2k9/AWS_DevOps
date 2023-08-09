# --- root/main.tf ---

module "networking" {
  source   = "./networking"
  vpc_cidr = local.vpc_cidr
  #number of subnet to generate using cidrsubnet function  
  public_sn_count  = 2
  max_subnets      = 20
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  #for loop to generate subnet numbers using cidrsubnet function 
  public_cidrs  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]  
}

module "compute" {
  source         = "./compute"
  public_sg      = module.networking.public_sg
  public_subnets = module.networking.public_subnets  
  instance_count = 2
  instance_type  = "t2.micro"  
  public_key_path = var.public_key_path  
  key_name        = "trkey"   
}
