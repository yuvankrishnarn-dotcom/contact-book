data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data = <<EOF
#!/bin/bash
dnf install -y docker
systemctl enable docker
systemctl start docker
docker run -d -p 80:80 nginx
EOF

  tags = {
    Name = "${var.project}-backend"
  }
}

