# Smallstep CA with HSM support (Debian)

ARG SMALLSTEP_CA_VERSION=0.0.0
ARG SMALLSTEP_CLI_VERSION=0.0.0


FROM golang:bullseye AS builder

ARG SMALLSTEP_CA_VERSION

RUN apt-get update
RUN apt-get install -y build-essential libpcsclite-dev

WORKDIR /src

RUN curl -L https://github.com/smallstep/certificates/releases/download/v${SMALLSTEP_CA_VERSION}/step-ca_${SMALLSTEP_CA_VERSION}.tar.gz | tar xzf -
RUN make GOFLAGS="" V=1 build


FROM debian:bullseye

ARG SMALLSTEP_CLI_VERSION

COPY --from=builder /src/bin/step-ca            /usr/local/bin/step-ca
COPY --from=builder /src/bin/step-awskms-init   /usr/local/bin/step-awskms-init
COPY --from=builder /src/bin/step-cloudkms-init /usr/local/bin/step-cloudkms-init
COPY --from=builder /src/bin/step-pkcs11-init   /usr/local/bin/step-pkcs11-init
COPY --from=builder /src/bin/step-yubikey-init  /usr/local/bin/step-yubikey-init

USER root
RUN apt-get update
RUN apt-get install -y libcap2-bin && setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/step-ca
RUN apt-get install -y curl libpcsclite1 pcscd
RUN curl -L -o /tmp/step.deb https://dl.step.sm/gh-release/cli/gh-release-header/v${SMALLSTEP_CLI_VERSION}/step-cli_${SMALLSTEP_CLI_VERSION}_amd64.deb
RUN dpkg -i /tmp/step.deb && rm -f /tmp/step.deb

ENV STEPPATH="/opt/step"
ENV CONFIGPATH="/opt/step/config/ca.json"
ENV PWDPATH="/opt/step/secrets/password"

VOLUME ["/opt/step"]
STOPSIGNAL SIGTERM
HEALTHCHECK CMD step ca health 2>/dev/null | grep "^ok" >/dev/null

ENTRYPOINT /usr/local/bin/step-ca
CMD "--password-file $PWDPATH $CONFIGPATH"
