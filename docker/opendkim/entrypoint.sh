#!/bin/bash

if [[ -z "$(find /etc/opendkim/domainkeys -iname *.private)" ]]; then
  echo "opendkim ep: dont find keys to use in KeyTable & SigningTable -> STOP" >&2
  exit 1
fi

  cat > /etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
192.168.0.1/24
172.0.0.0/8

*.$maildomain
EOF

  cat > /etc/opendkim/KeyTable <<EOF
mail._domainkey.$maildomain $maildomain:mail:$(find /etc/opendkim/domainkeys -iname *.private)
EOF

  cat > /etc/opendkim/SigningTable <<EOF
*@$maildomain mail._domainkey.$maildomain
EOF

  chown opendkim:opendkim $(find /etc/opendkim/domainkeys -iname *.private)
  chmod 400 $(find /etc/opendkim/domainkeys -iname *.private)

exec "$@"
