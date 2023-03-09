#!/bin/bash

# Set variables for instance creation
AMI_ID="ami-082b1f4237bd816a1" # replace with desired AMI ID
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_ID="sg-017f5ac79caac7c6b" # replace with desired security group ID
SUBNET_ID="subnet-0bb79b484d5a54899" # replace with desired subnet ID
KEY_NAME="freqtrade" # replace with desired key pair name

# Create instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID --key-name $KEY_NAME --output text --query 'Instances[*].InstanceId')

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Set variables
#$INSTANCE_ID="your-instance-id"
$PUBLIC_IP=(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
$LOCAL_SCRIPT_PATH="C:\Users\pc\Desktop\New folder\run.sh"
$REMOTE_SCRIPT_PATH="/home/ununtu/myscript.sh"
$PEM_FILE_PATH="C:\Users\pc\Downloads\freqtrade.pem"

# Copy shell script to instance
scp -i $PEM_FILE_PATH $LOCAL_SCRIPT_PATH ubuntu@$PUBLIC_IP:$REMOTE_SCRIPT_PATH

# Run script on instance
ssh -i $PEM_FILE_PATH ubuntu@$PUBLIC_IP "bash $REMOTE_SCRIPT_PATH"

# Sleep for 5 minutes
sleep 300

# Terminate instance
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

echo "Instance terminated."
