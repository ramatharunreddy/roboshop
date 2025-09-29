#!/bin/bash

AMI_ID="ami-09c813fb7154"
SG_ID="sg-037505fdee775a221"
INSTANCE_TYPE="t3.micro"

INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID  --instance-type $INSTANCE_TYPE  --security-group-ids $SG_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' --query 'Instances[0].InstanceId' --output text)

echo $INSTANCE_ID
exit