#!/bin/bash
#!/
profiles=$( awk -F"\\\]|\\\[" '/^\[/{print $2}' ~/.aws/credentials)

# loop through multiple accounts
for profile in $profiles; do
	reportStatus=
  printf "Creating credential report for %s.\\n" "$profile"
	until [ "$reportStatus" == 'COMPLETE' ]; do
		reportStatus=$(aws --profile "$profile" --output=json iam generate-credential-report | grep State | awk -F\" '{print $4}')
		if [ "$reportStatus" != 'COMPLETE' ]; then
			echo "Waiting on report generation...( %s )" "$reportStatus"
			sleep 10
		fi
	done
	printf "Report iam_credential_report_"$profile".csv created.\\n"
	printf "Retrieving credential report for %s\\n\\n" "$profile"
	$(aws --profile "$profile" --output=json iam get-credential-report | grep Content | awk -F\" '{print $4}' | base64 -D > iam_credential_report_"$profile".csv)

done
