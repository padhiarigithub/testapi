#!/bin/bash

# AWS Region to use
AWS_REGION="ap-southeast-1"

# AMI ID for Amazon Linux 2
AMI_ID="ami-082b1f4237bd816a1"

# Instance type
INSTANCE_TYPE="t2.micro"

# Key pair name
KEY_NAME="freqtrade"

# Security group name
SECURITY_GROUP_NAME="my-security-group"

# User data script to install Node.js and Git
USER_DATA="#!/bin/bash
yum update -y
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
yum install -y nodejs
yum install -y git"

# Create security group
aws ec2 create-security-group --group-name "${SECURITY_GROUP_NAME}" --description "My security group"
aws ec2 authorize-security-group-ingress --group-name "${SECURITY_GROUP_NAME}" --protocol tcp --port 22 --cidr 0.0.0.0/0

# Launch EC2 instance with user data script
INSTANCE_ID=$(aws ec2 run-instances --image-id "${AMI_ID}" --instance-type "${INSTANCE_TYPE}" --key-name "${KEY_NAME}" --security-groups "${SECURITY_GROUP_NAME}" --user-data "${USER_DATA}" --query 'Instances[0].InstanceId' --output text)

# Wait for instance to start
aws ec2 wait instance-status-ok --instance-ids "${INSTANCE_ID}"

# Print instance IP address
INSTANCE_IP=$(aws ec2 describe-instances --instance-ids "${INSTANCE_ID}" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Instance IP address: ${INSTANCE_IP}"

# Wait for SSH to be available
while ! nc -w 1 "${INSTANCE_IP}" 22 >/dev/null 2>&1; do sleep 1; done

# SSH into instance and check Node.js and Git versions
ssh -o StrictHostKeyChecking=no -i "${KEY_NAME}.pem" ec2-user@"${INSTANCE_IP}" 'node --version && git --version'
