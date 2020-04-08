#! /bin/bash

# waiting to write in mail.log
while [ ! -f /var/log/mail.log ]
do
  sleep 0.5
done

# start tailing of mail.log
tail --follow /var/log/mail.log