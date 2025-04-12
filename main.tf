resource "aws_instance" "dbserver" {
  ami           = "${var.ami}"
  instance_type = "${var.typeofinstance}"
  key_name      = "${var.keyname}"
  availability_zone = "${var.az}"
  security_groups = [ aws_security_group.dbserversg.name ]
  tags = {
    Name       = "Machine1FromTerraform"
    Type       = "AppServer"
    Webserver  = "Nginx"
    managed-by = "Terraform"
  }
}

resource "aws_security_group" "dbserversg" {
  name        = "dbserversg"
  description = "DBServer Security Group"

  ingress {
    description      = "HTTP nginx webserver"
    from_port        = "${var.dbport}"
    to_port          = "${var.dbport}"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH Server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dbserversg"
  }
}

resource "aws_ebs_volume" "dbservervolume" {
    availability_zone = "${var.az}"
    size = "${var.dbsize}"
    tags = {
        Name = "dbservervolume"

    }
}

resource "aws_volume_attachment" "dbservervolumeattach" {
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.dbservervolume.id
    instance_id = aws_instance.dbserver.id
}
