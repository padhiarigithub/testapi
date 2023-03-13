#!/bin/bash

# Set variables
KEY_NAME="my-keypair"
AMI_ID="ami-082b1f4237bd816a1"
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_ID="sg-017f5ac79caac7c6b"
SCRIPT_URL="https://github.com/padhiarigithub/testapi/blob/main/run.sh"

# Create key pair
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem
chmod 400 $KEY_NAME.pem

# Launch instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SECURITY_GROUP_ID --query 'Instances[0].InstanceId' --output text)

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get public IP address of instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].PublicIpAddress')

# Copy shell script to instance
scp -i $KEY_NAME.pem https://github.com/padhiarigithub/testapi/blob/main/run.sh ubuntu@$PUBLIC_IP:/home/ec2-user/

# Run script on instance
ssh -i $KEY_NAME.pem ubuntu@$PUBLIC_IP 'bash /home/ec2-user/run.sh'
