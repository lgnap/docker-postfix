#!/bin/bash

enable_tls () {
  if [[ -n "$(find /etc/postfix/certs -iname *.crt)" && -n "$(find /etc/postfix/certs -iname *.key)" ]]; then
    # /etc/postfix/main.cf
    postconf -e smtpd_tls_cert_file=$(find /etc/postfix/certs -iname *.crt)
    postconf -e smtpd_tls_key_file=$(find /etc/postfix/certs -iname *.key)
    chmod 400 /etc/postfix/certs/*.*
    # /etc/postfix/master.cf
    postconf -M submission/inet="submission   inet   n   -   n   -   -   smtpd"
    postconf -P "submission/inet/syslog_name=postfix/submission"
    postconf -P "submission/inet/smtpd_tls_security_level=encrypt"
    postconf -P "submission/inet/smtpd_sasl_auth_enable=yes"
    postconf -P "submission/inet/milter_macro_daemon_name=ORIGINATING"
    postconf -P "submission/inet/smtpd_recipient_restrictions=permit_sasl_authenticated,reject_unauth_destination"
  fi
}

sasl () {
  # /etc/postfix/main.cf
  postconf -e smtpd_sasl_auth_enable=yes
  postconf -e broken_sasl_auth_clients=yes
  postconf -e smtpd_recipient_restrictions=permit_sasl_authenticated,reject_unauth_destination

  # smtpd.conf
  cat >> /etc/postfix/sasl/smtpd.conf <<EOF
  pwcheck_method: auxprop
  auxprop_plugin: sasldb
  mech_list: PLAIN LOGIN CRAM-MD5 DIGEST-MD5 NTLM
EOF

  # sasldb2
  echo $smtp_user | tr , \\n > /tmp/passwd
  while IFS=':' read -r _user _pwd; do
    echo $_pwd | saslpasswd2 -p -c -u $maildomain $_user
  done < /tmp/passwd

  chown postfix.sasl /etc/sasldb2
}

opendkim () {
  # /etc/postfix/main.cf
  postconf -e milter_protocol=2
  postconf -e milter_default_action=accept
  postconf -e smtpd_milters=inet:odkim:12301
  postconf -e non_smtpd_milters=inet:odkim:12301
}

############
#  postfix
############
postconf -e myhostname=$maildomain
postconf -F '*/*/chroot = n'

############
# SASL SUPPORT FOR CLIENTS
# The following options set parameters needed by Postfix to enable
# Cyrus-SASL support for authentication of mail clients.
############
sasl

############
# Enable TLS
############
enable_tls

#############
#  opendkim
#############
opendkim

exec "$@"
