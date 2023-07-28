# Ec2 instance connect role for console ssh to instance
resource "aws_iam_role" "ec2_instance_role" {
  name = var.ec2_instance_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "Ec2AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.ec2_instance_role_tags
}

# Creating instance profile from ec2_instance_role role
resource "aws_iam_instance_profile" "instance_profile_ec2_instance_role" {
  name = var.ec2_instance_role_instance_profile_name
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_attach_ssm_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# This policy is used to ssh ec2 instance through instance connect
resource "aws_iam_policy" "instance_connect_policy" {
  name        = var.instance_connect_policy_name
  path        = "/"
  description = var.instance_connect_policy_description
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ec2-instance-connect:SendSSHPublicKey"
        Effect   = "Allow"
        Sid      = "Ec2InstanceConnect"
        Resource = ["${aws_instance.private_ec2.arn}"]
        Condition = {
          "StringEquals" = {
            "ec2:osuser" = "ec2-user"
          }
        }
      },
      {
        Action   = "ec2:DescribeInstances"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
  depends_on = [
    aws_instance.private_ec2
  ]
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_attach_instance_connect_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.instance_connect_policy.arn
}