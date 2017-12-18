#!/bin/bash
#Export all GuardDuty Findigns In All Regions.

for region in $(aws ec2 describe-regions --output text | cut -f3)
do
  detector=$(aws guardduty list-detectors --region="$region" --output text | cut -f2)
    for finding in $(aws guardduty list-findings --detector-id="$detector" --region="$region" | grep -v -e \{ -e "\[" -e \] -e \} | tr -d '"' | tr -d ',' | tr -d ' ')
       do
       aws guardduty get-findings --detector-id="$detector" --finding-id="$finding" --region="$region" > "$region-$finding".json
       printf "Exporting Finding: %s-%s.json \n" "$region" "$finding"
       done
done
