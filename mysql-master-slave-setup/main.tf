
module "vpc" {
  source = "./modules/vpc"
}

module "master-sg" {
  sg_name = "mysql-master-sg"
  source  = "./modules/sg"
  vpc_id  = module.vpc.vpc_id
}

module "slave-sg" {
  sg_name = "mysql-slave-sg"
  source  = "./modules/sg"
  vpc_id  = module.vpc.vpc_id
}


module "mysql-master" {

  source                 = "./modules/ec2-instance"
  instance-name          = "MYSQL-MASTER-NODE"
  key_name               = "contact"
  ami                    = "ami-09b0a86a2c84101e1"
  vpc_security_group_ids = module.master-sg.master-sg-id
  iam_instance_profile   = "SSM-EC2-ROLE"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.public-subnet-1
  volume_size            = 8
  user_data              = "./mysql.sh"

}

module "mysql-slave" {

  source                 = "./modules/ec2-instance"
  instance-name          = "MYSQL-SLAVE-NODE"
  key_name               = "contact"
  ami                    = "ami-09b0a86a2c84101e1"
  iam_instance_profile   = "SSM-EC2-ROLE"
  vpc_id                 = module.vpc.vpc_id
  vpc_security_group_ids = module.slave-sg.slave-sg-id
  subnet_id              = module.vpc.public-subnet-2
  volume_size            = 8
  user_data              = "./mysql.sh"

}


output "master-ip" {
  description = "master-node-ip"
  value       = module.mysql-master.ec2-ip

}


output "slave-ip" {
  description = "master-node-ip"
  value       = module.mysql-slave.ec2-ip

}
