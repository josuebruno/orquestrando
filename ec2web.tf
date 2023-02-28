provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name = "web"
  }

  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  user_data = <<-EOF
              <powershell>
              Install-WindowsFeature Web-Server
              netsh advfirewall firewall add rule name="HTTP" dir=in action=allow protocol=TCP localport=80
              netsh advfirewall firewall add rule name="Port3358" dir=in action=allow protocol=TCP localport=3358
              netsh advfirewall firewall add rule name="Port5986" dir=in action=allow protocol=TCP localport=5986
              </powershell>
              EOF
}

resource "aws_security_group" "web" {
  name_prefix = "web-"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3358
    to_port = 3358
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5986
    to_port = 5986
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
