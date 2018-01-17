  output "puppet_master_private" { 
    value = "${aws_instance.web.private_dns}"
  }
  output "puppet_master_public" { 
    value = "${aws_instance.web.public_dns}"
  }

# Declare the instance resource here
resource "aws_instance" "web" {
  associate_public_ip_address = "true"
  key_name                    = "${var.key_name}"
  instance_type               = "m3.large"
  security_groups             = ["${var.security_groups}"] 
  subnet_id                   = "${var.subnet_id}" 
  ami                         = "${var.aws_ami}"


## Copy the pe.conf file over to the server
  provisioner "file" {
    source      = "conf/pe.conf"
    destination = "/home/ec2-user/pe.conf"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("${path.module}/${var.key_file}")}"
    agent       = "false"
    timeout     = "5m"
   }
  }

  provisioner "remote-exec" {
    inline = [
      # Download and extract the PE Master files.
      "curl -o ${var.dl_file} -L \"https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest\"",
      "mkdir -p ${var.dl_folder}",
      "mv /home/ec2-user/pe.conf ${var.dl_folder}",
      "tar zvxf puppetmaster.tar.gz -C ${var.dl_folder} --strip-components=1",
      "cd ${var.dl_folder}",
      "sudo bash -c \"./puppet-enterprise-installer -c pe.conf\"",
      "sudo bash -c \"/opt/puppetlabs/bin/puppet agent -t\"",
      "sudo bash -c \"/opt/puppetlabs/bin/puppet agent -t\"",
      "sudo bash -c \"/opt/puppetlabs/bin/puppet module install beersy-pe_code_manager_easy_setup --version 2.0.2\"",
      "sudo bash -c \"/opt/puppetlabs/bin/puppet agent -t\"",
      "sudo bash -c \"/opt/puppetlabs/bin/puppet agent -t\"",
      "sudo bash -c \"/bin/touch /root/.puppetlabs/token\"",
      "sleep 3",
      "sudo bash -c \"/bin/curl -k -X POST -H 'Content-Type: application/json' -d '{\"login\": \"admin\", \"password\": \"puppetlabs\"}' https://${aws_instance.web.private_dns}:4433/rbac-api/v1/auth/token >> ~/.puppetlabs/token\"",
      "sleep 3",
     # "sudo bash -c \"/opt/puppetlabs/bin/puppet-task run pe_code_manager_easy_setup::setup_code_manager r10k_remote_url=git@github.com:tspeigner/control-repo-1.git\"",
      "echo \"Now, put this generated Public SSH Key in your version control system:\"",
     # "echo \"$(sudo /usr/bin/head -n 1 /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub)\"",
     # "echo ********************************",
     # "echo \"Also, put the appropriate webhook URL's in your version control system:\"",
     # "webhook_url=$(sudo /usr/bin/head -n 1 /etc/puppetlabs/puppetserver/.puppetlabs/webhook_url.txt)",
     # "echo More information about webhook url's and all their parameters can be found here:",
     # "echo https://puppet.com/docs/pe/2017.3/code_management/code_mgr_webhook.html#triggering-code-manager-with-a-webhook"
    ]
   connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("${path.module}/${var.key_file}")}"
    agent       = "false"
    timeout     = "5m"
   }
  }

  tags {
    Name    = "master.inf.puppet.vm"
    Owner   = ""
    Purpose = ""
    Tech    = "Terraform"
  }
}
