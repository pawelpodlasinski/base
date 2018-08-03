#!/bin/sh

# check php version
php-fpm -v | grep -q '7.2' || (echo -e "Incorrect PHP version" && exit 1)
# check startup errors
stderr=$(php-fpm -v </dev/stdin 2>&1 1>&3)
echo $stderr | grep -qv "PHP Warning" || (echo -e "PHP startup errors" && exit 1)
