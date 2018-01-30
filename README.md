# AWS Scripts
Various AWS Automation Scripts

A collection of shell scripts for automating various security tasks with Amazon Web Services.<br>
You will need the [AWS-CLI](https://aws.amazon.com/cli/) installed and configured to make this work correctly.

## Scripts

**_WAF/WAF.SH_**: Creates a WAF using cloud formation and a rules template.<br>

**_ACM/acmdigicert.sh_**: Creates Digicert TLS certificates using their API and uploads them to ACM.<br>

**_Cloudfront/quickaudit.sh_**: Quickly audits CloudFront for WAF, Logging, TLS and HTTP Only usage.<br>

**_EC2/noingress.sh_**: Lists all in-use security groups that allow 0.0.0.0/0 for your inspection.

**_EC2/notused.sh_**: Lists all unused security groups that can likely be removed.

**_EC2/instances.sh_**: Lists all EC2 Instances in all AvailabilityZones.

**_EC2/SecurityGroups/addssh.sh_**: Adds rule to allow SSH access from your current public IP address.

**_EC2/SecurityGroups/removessh.sh_**: Removes rules allowing SSH access from your current public IP address.

**_GuardDuty/enale.sh_**: Enables GuardDuty in all available regions.

**_GuardDuty/findings.sh_**: Exports all GuardDuty findings to .json files.

**_S3/policies.sh_**: Lists all ACLs for S3 buckets in your account.

**_IAM/EC2USEastOnly.json**: IAM policy that only allows EC2 instances in US-East-1. 

## Important Notice
*I likely dont know what I am doing and this could be done faster, better and simpler some other way. These scripts could also break your cloud and make you cry.*
