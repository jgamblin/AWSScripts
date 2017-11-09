#!/bin/bash

#Find Bad Network Rules:
Open=$(aws ec2 describe-security-groups --filters "Name=ip-permission.cidr,Values=0.0.0.0/0" --query "SecurityGroups[].[GroupId, GroupName]" --output text)

#Add a line
printf "\n"

#Display Title.
printf "The Following Security Groups Have No Ingress Filtering: \033[0K\r"
printf '\n'

while read -r line; do
  GroupId=$(echo "$line" | awk '{print $1;}')
  GroupName=$(echo "$line" | awk '{print $2;}')
  Count=$(aws ec2 describe-network-interfaces --filters "Name=group-id,Values=$GroupId" --query "length(NetworkInterfaces)" --output text)
  if [[ $Count -ne 0 ]]
  then
    printf "%s(%s) is being used on %s EC2 Server(s)." "$GroupName" "$GroupId" "$Count"
    printf '\n'
  else
    :
  fi
done <<< "$Open"
