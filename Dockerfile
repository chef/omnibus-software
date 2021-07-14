FROM chefes/releng-base

ARG SOFTWARE
ARG VERSION

COPY ./ /omnibus-software
COPY ./test /test

WORKDIR /test

RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P omnibus-toolchain

RUN . /opt/omnibus-toolchain/bin/load-omnibus-toolchain \
    && DEBUG=1 bundle install --without development \
    && bundle exec omnibus build test