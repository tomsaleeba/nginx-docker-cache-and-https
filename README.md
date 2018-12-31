A demo that runs nginx as a reverse proxy for a basic web app. Nginx performs caching of
responses that have the header that allows it and also terminates HTTPS connections.

## How to run

You'll need to following tools to run this demo:

 - docker 18.09+
 - docker-compose 1.20+
 - nodejs 8+
 - yarn
 - curl
 - openssl

Follow these steps

  1. first we need to install some dependencies
      ```bash
      pushd app/
      yarn
      popd
      ```
  1. next, we need a certificate for HTTPS
      ```bash
      ./generate-cert.sh
      ```
  1. create a mapping on your system so the `blah.local` hostname resolves to `localhost`
      ```bash
      echo '127.0.0.1   blah.local' | sudo tee -a /etc/hosts
      ```
  1. now we start the server stack
      ```bash
      docker-compose up -d
      ```
  1. we're up and running. Let's make a HTTP call that *will NOT* be cached (due to the `Cache-Control` response header)
      ```bash
      # first call always takes time
      curl --cacert ./workdir/certs/blah.local.crt https://blah.local/nocache
      # second call isn't any faster as it wasn't cached
      curl --cacert ./workdir/certs/blah.local.crt https://blah.local/nocache
      ```
  1. now we'll make a cached call
      ```bash
      # first call always takes time
      curl --cacert ./workdir/certs/blah.local.crt https://blah.local/cache
      # second call is instant as it was cached
      curl --cacert ./workdir/certs/blah.local.crt https://blah.local/cache
      ```
  1. as a bonus, we can show automatic redirection from HTTP to HTTPS
      ```bash
      # note than we get a 301 to the HTTPS URL
      curl -v -L --cacert ./workdir/certs/blah.local.crt http://blah.local/cache
      ```
  1. finally, shut down the stack
      ```bash
      docker-compose down --volumes
      ```
