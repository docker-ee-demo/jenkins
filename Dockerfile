ARG base_image=jenkins/jenkins:2.200-alpine

FROM ${base_image}

ARG docker_version="19.03.3-r0"
ARG kubectl_version="1.14.6"

ENV DOCKER_PACKAGE_VERSION=${docker_version}
ENV KUBECTL_VERSION=${kubectl_version}

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER root

RUN echo "@edge-community http://dl-3.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
&& apk update \
&& apk add docker@edge-community=${DOCKER_PACKAGE_VERSION} gettext \
&& curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v{$KUBECTL_VERSION}/bin/linux/amd64/kubectl \
&& chmod +x /usr/bin/kubectl

COPY jenkins/ /usr/share/jenkins/

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
