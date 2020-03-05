FROM ruby:2.4

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y \
    build-essential \
    curl \
    git-core \
    ntp \
    wget \
    zip unzip \
    xvfb \
    qt5-default \
    libqt5webkit5-dev \
    default-libmysqlclient-dev \
    aria2 \
    jq \
    iptables \
    sshpass \
    python-setuptools \
    netcat-openbsd \
    && apt-get clean

# Install gems from rubygems
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
ADD bundle_rubygem_installer.rb /tmp/bundle_rubygem_installer.rb
RUN cd /tmp && ./bundle_rubygem_installer.rb
RUN rm -Rf /tmp/*

# We have dependency conflicts with bosh_cli
# Install it outside of our bundle context
RUN gem install bosh_cli
