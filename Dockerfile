FROM elixir:alpine AS uniris-ci

ARG skip_tests=0
ARG MIX_ENV=dev

# CI
#  - compile
#  - release
#  - gen PLT

# running CI with proposal should generate release upgrade
#  - commit proposal
#  - compile
#  - run ci
#  - generate release upgrade

######### TODO
# TESTNET
#  - code
#  - release

# running TESTNET with release upgrade should ???

RUN apk add --no-cache --update \
  build-base bash gcc git npm python3 wget openssl libsodium-dev gmp-dev

# Install hex and rebar
RUN mix local.rebar --force \
 && mix local.hex --if-missing --force

WORKDIR /opt/code

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# build assets
COPY assets ./assets 
<<<<<<< HEAD
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error \
 && npm --prefix ./assets run deploy
=======
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error deploy

COPY config config
RUN mkdir -p priv/static 
RUN mix phx.digest 
>>>>>>> 4565ade... Fix config and priv/static for Dockerfile

COPY . .

RUN git config user.name uniris \
 && git config user.email uniris@uniris.io \
 && git remote add origin https://github.com/UNIRIS/uniris-node

# build release
RUN mix do phx.digest, distillery.release

# gen PLT
RUN [ $skip_tests -eq 0 ] && mix git_hooks.run pre_push || true

# Install
RUN mkdir /opt/app \
 && cd /opt/app \
 && tar zxf /opt/code/_build/${MIX_ENV}/rel/uniris_node/releases/*/uniris_node.tar.gz
CMD /opt/app/bin/uniris_node foreground

################################################################################

FROM uniris-ci as build

FROM alpine

RUN apk add --no-cache --update bash git openssl libsodium

COPY --from=build /opt/app /opt/app
COPY --from=build /opt/code/.git /opt/code/.git

WORKDIR /opt/code
RUN git reset --hard

WORKDIR /opt/app
CMD /opt/app/bin/uniris_node foreground
