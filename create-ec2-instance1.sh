#!/bin/bash

# Set your AWS region
export AWS_DEFAULT_REGION=ap-southeast-1

# Set your key pair name
KEY_NAME=freqtrade

# Set the security group id
SECURITY_GROUP_ID=sg-017f5ac79caac7c6b

# Set the AMI ID
AMI_ID=ami-082b1f4237bd816a1

# Set the instance type
INSTANCE_TYPE=t2.micro

# Set the script file path
SCRIPT_FILE_PATH=/c/Users/pc/Desktop/New_folder/run.sh

# Create the security group
aws ec2 create-security-group --group-name $SECURITY_GROUP_ID --description "My security group"

# Open port 22 for SSH
aws ec2 authorize-security-group-ingress --group-name $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

# Launch the instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-groups $SECURITY_GROUP_NAME --query 'Instances[0].InstanceId' --output text)

echo "Instance created with ID: $INSTANCE_ID"

# Wait for the instance to start running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "Public IP address of the instance: $PUBLIC_IP"

# Copy the script file to the instance
scp -i ~/.ssh/$KEY_NAME.pem $SCRIPT_FILE_PATH ubuntu@$PUBLIC_IP:~

# Run the script on the instance
ssh -i ~/.ssh/$KEY_NAME.pem ubuntu@$PUBLIC_IP 'bash ~/run.sh'
