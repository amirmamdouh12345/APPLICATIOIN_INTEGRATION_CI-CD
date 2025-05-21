
# public node group
resource "aws_eks_node_group" "saay_public_node_group" {
  cluster_name = aws_eks_cluster.saayeks.name
  node_group_name = "saay_public_node_group"
  node_role_arn = "arn:aws:iam::277707121935:role/eks_node_group_role"
  subnet_ids = [aws_subnet.public_subnet.id]



    scaling_config {
      desired_size = 1
      max_size = 2
      min_size = 0
    }

  launch_template {
    id      = aws_launch_template.eks_node_lt.id
    version = "$Latest"
  }


    # put the public key for SSH
    remote_access {
      ec2_ssh_key = aws_key_pair.tf_key.key_name
    }    
}


resource "aws_launch_template" "eks_node_lt" {
  name_prefix   = "eks-node-lt-"
  image_id      = data.aws_ami.eks_worker.id 
  instance_type = "t2.medium"

  vpc_security_group_ids = [aws_security_group.eks_node_group_sg.id]

  key_name = aws_key_pair.tf_key.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "eks-node"
    }
  }
}


resource "aws_security_group" "eks_node_group_sg" {
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
    }

    tags = {
        Name = "eks_node_group_sg"
    }
}









//***************************************************************************


//permissions of both node_groups
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks_node_group_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service" : "ec2.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks-CNIPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}
