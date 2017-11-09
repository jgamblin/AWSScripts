#!/bin/bash

# Settings
OpenPort="22"
IP=$(curl -s http://checkip.amazonaws.com)
security_groups=$(aws ec2 describe-security-groups --query "SecurityGroups[].[GroupId, GroupName]" --output text | awk '{print $2;}')

for security_group in $security_groups
do
  printf "Adding access from %s to port %s in the %s security group." "$IP" "$OpenPort" "$security_group"
  printf "\n"
  aws ec2 authorize-security-group-ingress --group-name "$security_group" --ip-permissions '[{"IpProtocol": "tcp", "FromPort": '$OpenPort', "ToPort": '$OpenPort', "IpRanges": [{"CidrIp": "'"$IP"'/32", "Description": "SSH Access Added From Script"}]}]'
done
