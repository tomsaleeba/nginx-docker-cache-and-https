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
  1. now we start the server stack
      ```bash
      docker-compose up -d
      ```
  1. we're up and running. Let's make a HTTP call that *will NOT* be cached (due to the `Cache-Control` response header)
      ```bash
      # first call always takes time
      curl \
        --cacert ./workdir/certs/blah.local.crt \
        --resolve 'blah.local:443:127.0.0.1' \
        https://blah.local/nocache
      # second call isn't any faster as it wasn't cached
      curl \
        --cacert ./workdir/certs/blah.local.crt \
        --resolve 'blah.local:443:127.0.0.1' \
        https://blah.local/nocache
      ```
  1. now we'll make a cached call
      ```bash
      # first call always takes time
      curl \
        --cacert ./workdir/certs/blah.local.crt \
        --resolve 'blah.local:443:127.0.0.1' \
        https://blah.local/cache
      # second call is instant as it was cached
      curl \
        --cacert ./workdir/certs/blah.local.crt \
        --resolve 'blah.local:443:127.0.0.1' \
        https://blah.local/cache
      ```
  1. as a bonus, we can show automatic redirection from HTTP to HTTPS
      ```bash
      # note than we get a 301 to the HTTPS URL
      curl \
        --head \
        --resolve 'blah.local:80:127.0.0.1' \
        http://blah.local/cache
      ```
  1. we can also see an endpoint where the upstream doesn't define a cache policy, but we disable caching in nginx
     config
      ```bash
      # first call takes a while
      curl \
        --cacert ./workdir/certs/blah.local.crt \
        --resolve 'blah.local:443:127.0.0.1' \
        https://blah.local/api
      # second call takes just as long, which is what we want. Always fresh data from the API!
      curl \
        --cacert ./workdir/certs/blah.local.crt \
        --resolve 'blah.local:443:127.0.0.1' \
        https://blah.local/api
      ```
  1. finally, shut down the stack
      ```bash
      docker-compose down --volumes
      ```
