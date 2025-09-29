#!/bin/bash

AMI_ID='ami-09c813fb71547fc4f'
SG_ID='sg-037505fdee775a221'
INSTANCE_TYPE='t3.micro'


for instance_name in $@ ;do 

echo "launching $instance_name  instances"
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID  --instance-type $INSTANCE_TYPE  --security-group-ids $SG_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]' --query 'Instances[0].InstanceId' --output text)
echo $INSTANCE_ID

echo "adding ip in host zones"
if [[ $instance_name != "frontend" ]]
Host_name='$instance_name.devops97.fun'
IP_Addr=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[0].PrivateIpAddress' --output text)
aws route53 change-resource-record-sets --hosted-zone-id Z0837773NI779BRBSXZP --change-batch '{ "Comment": "Updating record set" ,"Changes": [{"Action": "UPSERT","ResourceRecordSet" : {"Name": "$Host_name": "A","TTL": 1,"ResourceRecords"  : [{"Value" : "$IP_Addr"}]}}]}'
else 
Host_name='devops97.fun'
IP_Addr=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[0].PublicIpAddress' --output text)
aws route53 change-resource-record-sets --hosted-zone-id Z0837773NI779BRBSXZP --change-batch '{ "Comment": "Updating record set" ,"Changes": [{"Action": "UPSERT","ResourceRecordSet" : {"Name": "$Host_name","Type": "A","TTL": 1,"ResourceRecords"  : [{"Value" : "$IP_Addr"}]}}]}'
done

exit
