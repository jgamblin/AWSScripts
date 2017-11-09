#!/bin/bash
# Creates a WAF in AWS via CloudFromation
# Remove >> /dev/null for verbose output.

STACKNAME=$1

#Uncomment 1 Line Below To Select Rule Set:

#OWASP Default Rules:
TEMPLATELOCATION=https://raw.githubusercontent.com/awslabs/aws-waf-sample/master/waf-owasp-top-10/owasp_10_base.yml

#AWS Deafult Rules:
#TEMPLATELOCATION=https://s3.amazonaws.com/solutions-reference/aws-waf-security-automations/latest/aws-waf-security-automations.template

#VILIDATION:
printf '\n'
printf "Validating WAF Template. \033[0K\r"
printf '\n'
aws cloudformation validate-template --template-body "$TEMPLATELOCATION" >> /dev/null

#CREATING STACK:
printf '\n'
printf "Creating WAF Template: \033[0K\r"
printf '\n'
aws cloudformation create-stack --stack-name "$STACKNAME" --template-body "$TEMPLATELOCATION" --capabilities CAPABILITY_NAMED_IAM

printf '\n'
printf "Done! Check Cloud Formation Console For Build Process.\033[0K\r"
printf '\n'
