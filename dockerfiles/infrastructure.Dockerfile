FROM pivotalcfreleng/ruby
MAINTAINER https://github.com/pivotal-cf/pcf-releng-ci

ENV TERRAFORM_VERSION 0.11.14

RUN \
      apt-get update && \
      apt-get -qqy install \
        apt-transport-https \
        python2.7 \
        python-dev \
        python-pip \
        unzip \
        bsdmainutils \
        mysql-client \
      && \
      apt-get clean

# install terraform now a dependency of bbl for gcp installs
RUN curl -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

# install bbl
COPY bbl-release/bbl-*_linux* /go/bin/bbl
RUN chmod +x /go/bin/bbl

# install leftovers
COPY leftovers-release/leftovers-*-linux* /go/bin/leftovers
RUN chmod +x /go/bin/leftovers

# install bosh v2 cli
COPY bosh-cli-release/bosh-cli-*-linux* /go/bin/bosh
RUN chmod +x /go/bin/bosh

# install credhub cli
COPY credhub-cli-release/credhub-linux* /tmp/credhub.tgz
RUN tar -xvf /tmp/credhub.tgz && \
    mv credhub /go/bin/credhub && \
    chmod +x /go/bin/credhub

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip" && \
  unzip /tmp/awscli-bundle.zip -d /tmp && \
  /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
  rm -f /tmp/awscli-bundle.zip && \
  rm -rf /tmp/awscli-bundle

# Install gcloud
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && \
  apt-get -qqy install google-cloud-sdk

# install Azure CLI
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list && \
  curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  apt-get update && apt-get -qqy install --fix-missing azure-cli && apt-get clean

# Install yq
RUN pip install yq

# Install Node 9
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
  apt-get install -y nodejs
