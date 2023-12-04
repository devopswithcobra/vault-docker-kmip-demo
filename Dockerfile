# base image
FROM alpine:latest

# set vault version
ENV VAULT_VERSION 1.12.1

# create a new directory
RUN mkdir /vault

# download dependencies
RUN apk --no-cache add \
      bash \
      ca-certificates \
      wget

# download and set up vault
RUN wget --quiet --output-document=/tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_arm64.zip && \
    unzip /tmp/vault.zip -d /vault && \
    rm -f /tmp/vault.zip && \
    chmod +x /vault

# update PATH
ENV PATH="PATH=$PATH:$PWD/vault"

# add the config file
COPY ./config/vault-config.json /vault/config/vault-config.json
COPY ./config/selfsigned.crt /vault/config/selfsigned.crt
COPY ./config/selfsigned.key /vault/config/selfsigned.key
# expose port 8200
EXPOSE 8200

# run vault
ENTRYPOINT ["vault"]
