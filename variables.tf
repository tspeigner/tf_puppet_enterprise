#####################################
# AWS Information
#####################################
variable "aws_ami" {
  description = "Which AWS AMI should you use"
  default     = "ami-6f68cf0f"
  ## RHEL-7.3_HVM_GA-20161026-x86_64-1-Hourly2-GP2 (ami-6f68cf0f)
}

variable "count" {
  description = "How many instances to provision"
  default     = "1"
}

variable "instance_type" {
  description = "What type of AWS instnace do you want to use? This will be a list eventually."
  default     = "m3.large"
}

variable "key_name" {
  description = "AWS Authentication key"
  default     = "tommy"
}

variable "security_groups" {
  default     = "sg-190e7962"
}

variable "subnet_id" {
  default     = "subnet-fdbb3198"
}

#####################################
# Puppet Information
#####################################

variable "dl_folder" {
  description = "The directory to extract the downloaded file to"
  default     = "/home/ec2-user/puppetmaster"
}

variable "dl_file" {
  description = "PE downloaded file name"
  default     = "puppetmaster.tar.gz"
}

variable "puppet_master_installer" {
  description = "Location of the Puppet Master installation files"
  default     = "https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest"
}

variable "key_file" {
  description = ""
  default     = "tommy.pem"
}
