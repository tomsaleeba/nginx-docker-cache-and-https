#!/bin/bash
# (re)generates certificate and key for HTTPS connections. It is non-interactive.
set -e
cd `dirname "$0"`

certFile=./workdir/certs/blah.local.crt
keyFile=./workdir/certs/blah.local.key
wwwCertFile=./workdir/certs/www.blah.local.crt
wwwKeyFile=./workdir/certs/www.blah.local.key

rm -f $certFile $keyFile $wwwCertFile $wwwKeyFile 2> /dev/null

openssl req \
  -newkey rsa:2048 \
  -nodes \
  -keyout $keyFile \
  -x509 \
  -days 365 \
  -subj /C=AU/ST=SA/L=Adelaide/O=Blah/CN=blah.local \
  -out $certFile

openssl req \
  -newkey rsa:2048 \
  -nodes \
  -keyout $wwwKeyFile \
  -x509 \
  -days 365 \
  -subj /C=AU/ST=SA/L=Adelaide/O=Blah/OU=Asdf/CN=www.blah.local \
  -out $wwwCertFile

echo "[INFO] view the cert with the following commands:"
echo "[INFO]   openssl x509 -noout -text -in $certFile"
echo "[INFO]   openssl x509 -noout -text -in $wwwCertFile"
