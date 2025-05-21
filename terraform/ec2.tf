resource "aws_key_pair" "tf_key" {
  key_name   = "ec2-key"
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa-4096.private_key_pem
  filename = "ec2.pem"

}



