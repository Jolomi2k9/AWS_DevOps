# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "random_id" "tr_instance_id" {
  byte_length = 2
  count       = var.instance_count
  #forces random id to also be replaced when instances are replaced
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "tr_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "tr_node" {  
  instance_type = var.instance_type 
  ami           = data.aws_ami.server_ami.id    

  key_name               = aws_key_pair.tr_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[0]
  
  for_each = toset(["jenkins-master", "build-slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }  
}







