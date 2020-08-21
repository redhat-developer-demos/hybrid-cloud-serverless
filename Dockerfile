FROM quay.io/openshift/origin-cli

RUN wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64  \
  && wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 \
  && chmod +x /usr/local/bin/yq /usr/local/bin/jq