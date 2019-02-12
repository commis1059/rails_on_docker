FROM node:8 as node
FROM ruby:2.6

ARG TIMEZONE="Asia/Tokyo"

ENV LANG C.UTF-8
ENV ENTRYKIT_VERSION 0.4.0

COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /opt/yarn-v*/bin/* /opt/yarn/bin/
COPY --from=node /opt/yarn-v*/lib/* /opt/yarn/lib/

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

RUN set -x && \
  apt-get update -qq && \
  apt-get install -y mysql-client vim && \
  mkdir /app && \
  : "timezone" && \
  unlink /etc/localtime && \
  ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  : "yarn" && \
  ln -s /opt/yarn/bin/yarn /usr/local/bin/ && \
  ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/ && \
  : "gem" && \
  echo 'install: --no-document' >> ~/.gemrc && \
  echo 'update: --no-document' >> ~/.gemrc && \
  : "cleanup" && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["prehook", "bundle install -j2", "--", "prehook", "rm -f tmp/pids/server.pid", "--"]
