#!/bin/bash
service postfix start

# waiting postfix to start and write in mail.log
while [ ! -f /var/log/mail.log ]
do
  sleep 0.5
done

# start tailing of mail.log & put in background allowing tail errors at the same time
tail --follow /var/log/mail.log &

# start tailing of mail.err & stderr it
tail --follow /var/log/mail.err >&2