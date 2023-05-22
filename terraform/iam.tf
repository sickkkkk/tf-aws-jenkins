resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "devEcsTaskExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "bastion_bootstrap_role" {
  name               = "devBastionBootstrapRole"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "bastion_bootstrap_policy" {
  name        = "bastion_bootstrap_policy"
  path        = "/"
  description = "Allows bootstrap specific actions"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowECRActions",
            "Effect": "Allow",
            "Action": [
                "ecr:GetRegistryPolicy",
                "ecr:CreateRepository",
                "ecr:DescribeRegistry",
                "ecr:DescribePullThroughCacheRules",
                "ecr:GetAuthorizationToken",
                "ecr:PutRegistryScanningConfiguration",
                "ecr:CreatePullThroughCacheRule",
                "ecr:DeletePullThroughCacheRule",
                "ecr:PutRegistryPolicy",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:BatchImportUpstreamImage",
                "ecr:DeleteRegistryPolicy",
                "ecr:PutReplicationConfiguration"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowECRActionsForRepo",
            "Effect": "Allow",
            "Action": "ecr:*",
            "Resource": "arn:aws:ecr:eu-central-1:623180997824:repository/ecr_repo"
        },
        {
            "Sid": "AllowS3ReadAccess",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        },
        {
          "Sid": "AllowSecretsManagerAccess",
          "Effect": "Allow",
          "Action": [
              "secretsmanager:DescribeSecret",
              "secretsmanager:PutSecretValue",
              "secretsmanager:CreateSecret",
              "secretsmanager:DeleteSecret",
              "secretsmanager:CancelRotateSecret",
              "secretsmanager:ListSecretVersionIds",
              "secretsmanager:UpdateSecret",
              "secretsmanager:GetResourcePolicy",
              "secretsmanager:GetSecretValue",
              "secretsmanager:StopReplicationToReplica",
              "secretsmanager:ReplicateSecretToRegions",
              "secretsmanager:RestoreSecret",
              "secretsmanager:RotateSecret",
              "secretsmanager:UpdateSecretVersionStage",
              "secretsmanager:RemoveRegionsFromReplication"
          ],
          "Resource": "arn:aws:secretsmanager:*:623180997824:secret:*"
      },
      {
          "Sid": "AllowSecretsManagerAccess0",
          "Effect": "Allow",
          "Action": [
              "secretsmanager:GetRandomPassword",
              "secretsmanager:ListSecrets"
          ],
          "Resource": "*"
      }
    ]
})
}

resource "aws_iam_policy_attachment" "bastion_bootstrap_role-attachment" {
  name       = "devBastionBootstrapRole_attachment"
  roles      = [aws_iam_role.bastion_bootstrap_role.name]
  policy_arn = aws_iam_policy.bastion_bootstrap_policy.arn
}

resource "aws_iam_instance_profile" "bastion_bootstrap_role-profile" {
  name = "devBastionBootstrapRole_profile"
  role = aws_iam_role.bastion_bootstrap_role.name
}