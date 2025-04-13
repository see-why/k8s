#!/bin/bash

# Exit on error
set -e

# Configuration variables
KEY_NAME="ec2-kp"
SECURITY_GROUP_NAME="ec2-sg"
VPC_ID="vpc-0b9e0a7056b488f7d"
SUBNET_ID="subnet-0fb64791d6aeca32f"
AMI_ID="ami-0f9de6e2d2f067fca"
INSTANCE_TYPE="t2.micro"
INSTANCE_NAME="web-server"

# Create key pair
echo "Creating key pair..."
aws ec2 create-key-pair \
    --key-name "$KEY_NAME" \
    --key-type "rsa" \
    --key-format "pem" \
    --query 'KeyMaterial' \
    --output text > "${KEY_NAME}.pem"
chmod 400 "${KEY_NAME}.pem"

# Create security group
echo "Creating security group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "Opens security groups for ssh" \
    --vpc-id "$VPC_ID" \
    --query 'GroupId' \
    --output text)

# Authorize SSH access
echo "Authorizing SSH access..."
aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP_ID" \
    --ip-permissions '{"IpProtocol":"tcp","FromPort":22,"ToPort":22,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}'

# Launch EC2 instance
echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --network-interfaces "SubnetId=$SUBNET_ID,AssociatePublicIpAddress=true,DeviceIndex=0,Groups=[$SECURITY_GROUP_ID]" \
    --credit-specification '{"CpuCredits":"standard"}' \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --metadata-options '{"HttpEndpoint":"enabled","HttpPutResponseHopLimit":2,"HttpTokens":"required"}' \
    --private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":false,"EnableResourceNameDnsAAAARecord":false}' \
    --count 1 \
    --query 'Instances[0].InstanceId' \
    --output text)

# Wait for instance to be running
echo "Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get public IP address
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "Instance launched successfully!"
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "SSH command: ssh -i ${KEY_NAME}.pem ec2-user@$PUBLIC_IP" 