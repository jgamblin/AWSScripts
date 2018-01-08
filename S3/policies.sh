#!/bin/bash
#Lists all ACLs for S3 buckets in your account. 

#Remove Old Working Files.
rm -rf buckets.txt
rm -rf bucketpolicies.txt

#List All Buckets
aws s3 ls | awk '{print $3}' > buckets.txt

#Find & Print ACLs for Buckets
for i in $(cat buckets.txt)
do
        printf "$i \n" >> bucketpolicies.txt
        aws s3api get-bucket-acl --bucket "$i"  --output text >> bucketpolicies.txt
        printf "\n" >> bucketpolicies.txt
done
