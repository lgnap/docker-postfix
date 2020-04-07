#!/bin/bash

opendkim () {
  if [[ -z "$(find /etc/opendkim/domainkeys -iname *.private)" ]]; then
    return
  fi

  cat > /etc/opendkim.conf <<EOF
AutoRestart             Yes
AutoRestartRate         10/1h
UMask                   002
Syslog                  yes
SyslogSuccess           Yes
LogWhy                  Yes

Canonicalization        relaxed/simple

ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
SigningTable            refile:/etc/opendkim/SigningTable

Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256

UserID                  opendkim:opendkim

Socket                  inet:12301
EOF

  cat >> /etc/default/opendkim <<EOF
SOCKET="inet:12301"
EOF

  cat > /etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
192.168.0.1/24

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
}

opendkim

exec "$@"
