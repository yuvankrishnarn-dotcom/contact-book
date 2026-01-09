resource "aws_instance" "backend" {
  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_1.id

  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  user_data = <<EOF
#!/bin/bash
dnf install -y docker
systemctl enable docker
systemctl start docker
EOF

  tags = {
    Name = "${var.project}-backend"
  }
}

