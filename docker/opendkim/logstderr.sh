#! /bin/bash

# waiting to write in mail.err
while [ ! -f /var/log/mail.err ]
do
  sleep 0.5
done

# start tailing of mail.err & stderr it
tail --follow /var/log/mail.err >&2