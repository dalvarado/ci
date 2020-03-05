FROM pivotalcfreleng/minimal
MAINTAINER https://github.com/pivotal-cf/pcf-releng-ci

ENV GO_VERSION 1.12.2

# Install go
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
  rm -rf go${GO_VERSION}.linux-amd64.tar.gz

# Create directory for GOPATH
RUN mkdir -p /go/bin

# set GOPATH
ENV GOPATH /go

# add go and GOPATH/bin to PATH
ENV PATH $PATH:$GOPATH/bin:/usr/local/go/bin

# install ginkgo cli
RUN go get github.com/onsi/ginkgo/ginkgo

# install om
COPY om-release/om-linux /go/bin/om
RUN chmod +x /go/bin/om

# install kiln
COPY kiln-release/kiln-linux /go/bin/kiln
RUN chmod +x /go/bin/kiln

# install texplate
COPY texplate-release/texplate_linux_amd64 /go/bin/texplate
RUN chmod +x /go/bin/texplate

# install uptimer
# TODO: make this also use published releases
RUN go get github.com/cloudfoundry/uptimer

# install pivnet-cli
COPY pivnet-cli-release/pivnet-linux-amd64-* /go/bin/pivnet
RUN chmod +x /go/bin/pivnet

RUN chown -R testuser:testuser /go
