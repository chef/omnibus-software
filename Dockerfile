FROM chefes/releng-base

RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P omnibus-toolchain
