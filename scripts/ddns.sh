#!/bin/sh

# Update the DNS records for a domain on namecheap
DOMAIN=""
NC_PWD=""

# Get the registered IP in DNS and the our current public IP
dns_ip=$(dig $DOMAIN +short)
public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "DNS IP:    $dns_ip"
echo "Public IP: $public_ip"

# Send a curl request to update the IP if required
if [ "$public_ip" != "$dns_ip" ]; then
	curl -s -o /dev/null "https://dynamicdns.park-your-domain.com/update?host=@&domain=$DOMAIN&password=$NC_PWD&ip=$public_ip"
	curl -s -o /dev/null "https://dynamicdns.park-your-domain.com/update?host=*&domain=$DOMAIN&password=$NC_PWD&ip=$public_ip"
	echo "Curl requests sent with $public_ip"
fi
