# docker-postfix

This was inspired by good work from `catatnight/postfix`
But heavily changed so can't merge back into base repository

Run postfix with smtp authentication (sasldb) in a docker container.
TLS and OpenDKIM support are optional.

## Development

Check `docker-compose.yml` that I used to test the development

## Usage

Check `docker-compose.prod.yml` that I used to test the production deployment

## Note

+ Login credential should be set to (`username@mail.example.com`, `password`) in Smtp Client
+ You can assign the port of MTA on the host machine to one other than 25 ([postfix how-to](http://www.postfix.org/MULTI_INSTANCE_README.html))
+ Read the reference below to find out how to generate domain keys and add public key to the domain's DNS records

## Reference

+ [Postfix SASL Howto](http://www.postfix.org/SASL_README.html)
+ [How To Install and Configure DKIM with Postfix on Debian Wheezy](https://www.digitalocean.com/community/articles/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy)
+ TBD
