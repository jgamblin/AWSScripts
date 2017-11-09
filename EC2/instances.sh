#!/bin/bash
#List Instances In Each Region.
for region in `aws ec2 describe-regions --output text | cut -f3`
do
     aws ec2 describe-instances --region $region --output text --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, InstanceId, InstanceType, ImageId, PublicIpAddress ]'
done
