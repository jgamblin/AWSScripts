#!/bin/bash

#List SecurityGroups:
Open=$(aws --profile Alpha ec2 describe-security-groups --query "SecurityGroups[].[GroupId, GroupName]" --output text)

#Clear The Screen to make it pretty.
printf "\033c"

#Display Title.
printf "The Following Security Groups Are Not Used: \033[0K\r"
printf '\n'

while read -r line; do
  GroupId=$(echo $line | awk '{print $1;}')
  GroupName=$(echo $line | awk '{print $2;}')
  Count=$(aws ec2 describe-network-interfaces --filters "Name=group-id,Values=$GroupId" --query "length(NetworkInterfaces)" --output text)
  if [[ $Count -ne 0 ]]
  then
    :
  else
    printf "$GroupName($GroupId)"
    printf '\n'
  fi
done <<< "$Open"
