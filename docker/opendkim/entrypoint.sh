#!/bin/bash

DIRECTORY_DOMAIN_KEYS=/etc/opendkim/domainkeys

if [[ -z "$(find ${DIRECTORY_DOMAIN_KEYS} -iname "*.private")" ]]; then
  opendkim-genkey --directory="${DIRECTORY_DOMAIN_KEYS}" --domain="${maildomain}" --selector="${selector}"
fi

  cat > /etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
192.168.0.1/24
172.0.0.0/8

*.$maildomain
EOF

domainkeys=$(find ${DIRECTORY_DOMAIN_KEYS} -iname "*.private")

  cat > /etc/opendkim/KeyTable <<EOF
${selector}._domainkey.$maildomain $maildomain:${selector}:${domainkeys}
EOF

  cat > /etc/opendkim/SigningTable <<EOF
*@$maildomain ${selector}._domainkey.$maildomain
EOF

  chown opendkim:opendkim ${domainkeys} ${DIRECTORY_DOMAIN_KEYS}
  chmod 400 ${domainkeys}

exec "$@"
