FROM pivotalcfreleng/golang
MAINTAINER https://github.com/pivotal-cf/pcf-releng-ci

ENV RUBY_VERSION 2.4.5

RUN \
      apt-get update && \
      apt-get -qqy install --fix-missing \
        git-core \
        curl \
        zlib1g-dev \
        build-essential \
        libssl-dev \
        libreadline-dev \
        libyaml-dev \
        libsqlite3-dev \
        sqlite3 \
        libxml2-dev \
        libxslt1-dev \
        libcurl4-openssl-dev \
        python-software-properties \
        libffi-dev \
      && \
      apt-get clean


RUN git clone git://github.com/sstephenson/rbenv.git .rbenv
RUN git clone git://github.com/sstephenson/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"

ENV PATH "${HOME}/.rbenv/bin:${PATH}"
ENV PATH "${HOME}/.rbenv/plugins/ruby-build/bin:${PATH}"

RUN rbenv install -v "${RUBY_VERSION}"
RUN rbenv global "${RUBY_VERSION}"
ENV PATH "${PATH}:/root/.rbenv/versions/${RUBY_VERSION}/bin"

RUN gem install bundler

COPY ./ops-manager /tmp/ops-manager
WORKDIR /tmp/ops-manager/gems/ops-manifest

RUN bundle install && \
  rm -rf *.gem && \
  gem build ops-manifest.gemspec && \
  gem install ops-manifest-*.gem --no-document
