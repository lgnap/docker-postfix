#!/bin/bash

DIRECTORY_DOMAIN_KEYS=/etc/opendkim/domainkeys

rm -f /etc/opendkim/KeyTable
rm -f /etc/opendkim/SigningTable

echo "DNS records:"
for d in $OPENDKIM_DOMAINS ; do
  domain=$(echo "$d"| cut -f1 -d '=')
  selector=$(expr match "$d" '.*\=\(.*\)')
  if [ -z "$selector" ] ; then
    selector="mail"
  fi

  domainDir="${DIRECTORY_DOMAIN_KEYS}/$domain"
  privateFile="$domainDir/$selector.private"
  txtFile="$domainDir/$selector.txt"
  if [ ! -f "$privateFile" ] ; then
    echo "No DKIM private key found for selector '$selector' in domain '$domain'. Generating one now..."
    mkdir -p "$domainDir"
    opendkim-genkey -D "$domainDir" --selector="$selector" --domain="$domain" --append-domain
  fi

  # Ensure strict permissions required by opendkim
  chown opendkim:opendkim "$domainDir" "$privateFile"
  chmod a=,u=rw "$privateFile"

  echo "$selector._domainkey.$domain $domain:$selector:$privateFile" >> /etc/opendkim/KeyTable
  echo "*@$domain $selector._domainkey.$domain" >> /etc/opendkim/SigningTable

  cat "$txtFile"
done

chown opendkim:opendkim ${DIRECTORY_DOMAIN_KEYS}


exec "$@"
