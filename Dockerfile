FROM gizmochief7/atlassian-base:latest
MAINTAINER Justin Ayers <gizmochief7@gmail.com>

USER root:root
RUN set -x \
  && apt-get update \
  && apt-get install -y git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*
USER "${ATL_USER}":"${ATL_USER}"

ENV APP_VERSION 4.14
ENV APP_BASEURL ${ATL_BASEURL}/stash/downloads/binary
ENV APP_PACKAGE atlassian-bitbucket-${APP_VERSION}.tar.gz
ENV APP_URL     ${APP_BASEURL}/${APP_PACKAGE}

RUN set -x \
  && curl -kL "${APP_URL}" | tar -xz -C "${ATL_HOME}" --strip-components=1 \
  && mkdir -p "${ATL_HOME}/conf/Catalina" \
  && chmod -R 755 "${ATL_HOME}/temp" \
  && chmod -R 755 "${ATL_HOME}/logs" \
  && chmod -R 755 "${ATL_HOME}/work" \
  && chmod -R 755 "${ATL_HOME}/conf/Catalina"

ADD bitbucket-service.sh /opt/bitbucket-service.sh

EXPOSE 7990
EXPOSE 7999
CMD ["/opt/bitbucket-service.sh"]
