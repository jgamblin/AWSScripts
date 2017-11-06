#!/bin/bash
 
#Required
apikey=
domain=
commonname=$1
orgid=

#Change to your company details
country=
state=
locality=
organization=
organizationalunit=
email=
 
#Clear The Screen to make it pretty. 
printf "\033c"

#Optional
password=dummypassword
 
#Generate a key
printf "Creating Key.\033[0K\r"
printf '\n' 
openssl genrsa -des3 -passout pass:$password -out private.pem 2048 > /dev/null 2>&1
openssl rsa -passin pass:$password -in private.pem -out privateunencrypted.pem -outform PEM > /dev/null 2>&1

#Remove passphrase from the key. Uncomment the line to remove the passphrase
printf "Removing passphrase from key.\033[0K\r"
printf '\n' 
openssl rsa -in  private.pem  -passin pass:$password -out  private.key.pem -outform PEM > /dev/null 2>&1

#Create the request
printf "Creating CSR.\033[0K\r"
printf '\n' 
openssl req -new -key private.pem -out $commonname.csr -passin pass:$password \
   -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" > /dev/null 2>&1

#Fix CSR
csr=$(tr -d ' \t\n\r\f' <$commonname.csr )


#Setup Cert Request 
request_cert=$(< <(cat <<EOF
{
  "certificate": {
    "common_name": "$commonname",
    "csr": "$csr",
    "organization_units": [
      "Data Center"
    ],
    "server_platform": {
      "id": 45
    },
    "signature_hash": "sha256"
  },
  "organization": {
    "id": $orgid
  },
  "validity_years": 3,
  "disable_renewal_notifications": "true"
} 
EOF
))

#Setup Cert Issuse 
request_issue=$(< <(cat <<EOF
{
  "status": "approved"
}
EOF
))

printf "Requesting DigiCert Cert.\033[0K\r"
printf '\n' 
echo curl -s -H '"X-DC-DEVKEY: '${apikey}'"' -H '"Content-Type: application/json"' --data "'${request_cert}'" https://www.DigiCert.com/services/v2/order/certificate/ssl_plus > order.txt
bash order.txt > ordered.txt
sleep 2

printf  "Approving DigiCert Cert.\033[0K\r"
printf '\n' 
ordernumber=$(cat ordered.txt | tr ':' ',' | awk -F',' '$4 ~ /id/ {print $5}')
echo curl -s -X PUT -H '"X-DC-DEVKEY: '${apikey}'"' -H '"Content-Type: application/json"' --data "'${request_issue}'"  "https://www.DigiCert.com/services/v2/request/${ordernumber}/status" > approve.txt 
bash approve.txt 
sleep 2

printf  "Getting Cert Number.\033[0K\r"
printf '\n' 
otherordernumber=$(cat ordered.txt | tr ':' ',' | awk -F',' '$4 ~ /id/ {print $2}')
echo curl -s -H '"X-DC-DEVKEY: '${apikey}'"' -H '"Content-Type: application/json"'  "https://www.DigiCert.com/services/v2/order/certificate/${otherordernumber}" > cert.txt
bash cert.txt > certs.txt

#printf  "Sleeping For 10 Seconds To Allow Cert to Be Issued. \n"
secs=10
while [ $secs -gt 0 ]; do
   echo -ne "Sleeping for $secs Seconds To Allow Cert to Be Issued.\033[0K\r"
   sleep 1
   : $((secs--))
done
printf '\n' 
printf  "Downloading Certs.\033[0K\r"
printf '\n' 
certnumber=$(cat certs.txt | tr ':' ',' | awk -F',' '$4 ~ /id/ {print $5}')


#Uncomment for a single .pem file containing all the certs
echo curl -s -H '"X-DC-DEVKEY: '${apikey}'"' -H '"Accept: */*"' "https://www.DigiCert.com/services/v2/certificate/${certnumber}/download/format/pem_all" --output  $commonname.pem > pem.txt
bash pem.txt

#Split the Cert
openssl x509 -in $commonname.pem -outform pem -out host-cert.pem

#Upload to AWS:
printf  "Uploading Certs To AWS.\033[0K\r"
printf '\n' 

aws acm import-certificate --certificate file://host-cert.pem --certificate-chain file://$commonname.pem  --private-key file://privateunencrypted.pem > awsacm.txt

mkdir -p $commonname
mv *.txt $commonname
mv *.pem $commonname
mv *.csr $commonname
printf  "Done. Check AWS ACM Console. \033[0K\r"
sleep 10

