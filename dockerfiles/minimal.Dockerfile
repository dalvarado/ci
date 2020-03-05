FROM ubuntu:16.04
MAINTAINER https://github.com/pivotal-cf/pcf-releng-ci

# installing runit to provide chpst
RUN \
      apt-get update && \
      apt-get -qqy install software-properties-common && \
      add-apt-repository ppa:git-core/ppa -y && \
      apt-get update && \
      apt-get -qqy install --fix-missing \
        wget \
        dnsutils \
        git \
        runit \
        curl \
        tree \
        jq \
        build-essential \
        zip \
        unzip \
        poppler-utils \
        iputils-ping \
        python-setuptools \
        iptables \
        apt-transport-https \
        netcat-openbsd \
        vim \
      && \
      apt-get clean

# Create testuser
RUN mkdir -p /home/testuser && \
  groupadd -r testuser -g 433 && \
  useradd -u 431 -r -g testuser -d /home/testuser -s /usr/sbin/nologin -c "Docker image test user" testuser

# Add trusted releng ca certificate
ARG RELENG_CA_CERTIFICATE
ARG PREVIOUS_RELENG_CA_CERTIFICATE
RUN echo -n "$RELENG_CA_CERTIFICATE" > /usr/local/share/ca-certificates/releng.crt && \
    echo -n "$PREVIOUS_RELENG_CA_CERTIFICATE" > /usr/local/share/ca-certificates/previous_releng.crt && \
  /usr/sbin/update-ca-certificates -f

# Add sshuttle for testing in internetless environments
RUN easy_install pip && pip install sshuttle

# Add yq
RUN pip install yq
