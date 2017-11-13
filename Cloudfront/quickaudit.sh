#!/bin/bash
printf "Cloudfront Quick Audit Check.\n\n"
aws configure set preview.cloudfront true
cdns=$(aws cloudfront list-distributions  --query 'DistributionList.Items[].Id' --output text)
  for cdn in $cdns; do

    # Check if Cloudfront is using a WAF.
    printf "Security Audit for Cloudfront Distribution %s\n" "$cdn"
    check=$(aws cloudfront get-distribution --id "$cdn" --query 'Distribution.DistributionConfig.WebACLId' --output text)
    if [ ! "$check" ]; then
      printf "Does Not Have WAF Integration Enabled.\n"
    else
      :
    fi

    # Check if logging is enabled.
    check=$(aws cloudfront get-distribution  --id "$cdn" --query 'Distribution.DistributionConfig.Logging.Enabled' | grep true)
    if [ ! "$check" ]; then
      printf "Does Not Have Logging Enabled.\n"
    else
      :
    fi

    # Checks SSL protocol versions being used against deprecated list.
    check=$(aws cloudfront get-distribution  --id "$cdn" --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginSslProtocols.Items' | grep "SSLv3|SSLv2")
    if [ "$check" ]; then
      printf "Is Using A Deprecated Version of SSL.\n"
    else
      :
    fi

    # Check if HTTP only is being used.
    check=$(aws cloudfront get-distribution  --id "$cdn" --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginProtocolPolicy' | grep "http-only")
    if [ "$check" ]; then
      printf "Is Using HTTP Only.\n"
    else
      :
    fi
    printf "\n"
done
