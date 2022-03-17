FROM ubuntu:18.04

RUN apt-get update -y -q && apt-get install -y \
      autoconf \
      binutils \
      binutils-doc \
      bison \
      build-essential \
      curl \
      devscripts \
      dpkg-dev \
      fakeroot \
      flex \
      gettext \
      gnupg \
      ncurses-dev \
      ncurses-dev \
      wget \
      zlib1g-dev

RUN curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P omnibus-toolchain
