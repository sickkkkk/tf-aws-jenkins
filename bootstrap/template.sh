#!/bin/bash
set -x
# login to repo & build jenkins image
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin { ecr_repo_endpoint }
cd /home/ec2-user/jenkins-bootstrap/docker
docker build -t jenkins:ecs-master .
docker tag jenkins:ecs-master { ecr_repo_endpoint }/ecr_repo:jenkins-ecs-master_v1
docker push { ecr_repo_endpoint }/ecr_repo:jenkins-ecs-master_v1

# mount EFS
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport { efs_endpoint }:/ /mnt
sudo mkdir /mnt/jenkins-master
sudo chmod a+rwx /mnt/jenkins-master