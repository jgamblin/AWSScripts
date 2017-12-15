#!/bin/bash
#Enable GuardDuty In All Regions. 
for region in $(aws ec2 describe-regions --output text | cut -f3)
do
      aws guardduty --region "$region" create-detector
done
