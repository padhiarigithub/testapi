#!/bin/bash

# Set variables for EC2 instance configuration
AMI_ID="ami-082b1f4237bd816a1" # replace with desired AMI ID
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_ID="sg-017f5ac79caac7c6b" # replace with desired security group ID
SUBNET_ID="subnet-0bb79b484d5a54899" # replace with desired subnet ID
KEY_NAME="freqtrade.pem" # replace with desired key pair name
REGION="ap-southeast-1"
SCRIPT_URL="https://raw.githubusercontent.com/padhiarigithub/testapi/main/run.sh"

# Create instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --region $REGION \
  --query 'Instances[0].InstanceId' \
  --output text)

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get instance public IP address
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --region $REGION \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

# Download script to instance
scp -i  "C:\Users\pc\Downloads\freqtrade.pem" "C:\Users\pc\Downloads\run.sh" ubuntu@$PUBLIC_IP:/home/ec2-user/


# Run script on instance
cd /home/ec2-user/
ssh -i  "freqtrade.pem" ubuntu@$PUBLIC_IP 'bash /home/ec2-user/run.sh'



# Terminate instance after 2 minutes
sleep 600
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

