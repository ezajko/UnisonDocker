FROM centos:7

MAINTAINER Tremolo Security, Inc. - Docker <docker@tremolosecurity.com>
EXPOSE 9090
EXPOSE 8080
EXPOSE 8443
EXPOSE 9093

ENV UNISON_VERSION 1.0.6



USER root
ADD scripts/firstStart.sh /tmp/firstStart.sh
ADD conf/log4j.xml /tmp/log4j.xml
RUN yum -y install wget which;cd /etc/yum.repos.d;wget https://www.tremolosecurity.com/docs/tremolosecurity-docs/configs/tremolosecurity.repo;yum -y install unison && \
  userdel tremoloadmin && \
  groupadd -r tremoloadmin -g 433 && \
  useradd  -u 431 -r -g tremoloadmin -d /usr/local/tremolo/tremolo-service -s /sbin/nologin -c "Unison Docker image user" tremoloadmin && \
  mv /tmp/log4j.xml /usr/local/tremolo/tremolo-service/apps/proxy/WEB-INF/log4j.xml && \
  mkdir /usr/local/tremolo/tremolo-service/stash && \
  cp -r /usr/local/tremolo/tremolo-service/apps/proxy/auth /usr/local/tremolo/tremolo-service/stash/apps-proxy-auth && \
  cp -r /usr/local/tremolo/tremolo-service/conf /usr/local/tremolo/tremolo-service/stash/conf && \
  cp -r /usr/local/tremolo/tremolo-service/apps/proxy/WEB-INF /usr/local/tremolo/tremolo-service/stash/apps-proxy-WEB-INF && \
  cp -r /usr/local/tremolo/tremolo-service/apps/tremolo-admin/WEB-INF /usr/local/tremolo/tremolo-service/stash/apps-tremolo-admin-WEB-INF && \
  cp -r /usr/local/tremolo/tremolo-service/apps/webservices/WEB-INF /usr/local/tremolo/tremolo-service/stash/webservices-WEB-INF && \
  mv /tmp/firstStart.sh /usr/local/tremolo/tremolo-service/bin/ && \
  chmod +x /usr/local/tremolo/tremolo-service/bin/firstStart.sh && \
  chown -R tremoloadmin:tremoloadmin /usr/local/tremolo && \
  chmod -R ugo+rw /usr/local/tremolo && \
  yum -y clean all

VOLUME /usr/local/tremolo/tremolo-service/apps/proxy/auth
VOLUME /usr/local/tremolo/tremolo-service/conf
VOLUME /usr/local/tremolo/tremolo-service/apps/proxy/WEB-INF
VOLUME /usr/local/tremolo/tremolo-service/apps/tremolo-admin/WEB-INF
VOLUME /usr/local/tremolo/tremolo-service/apps/webservices/WEB-INF
VOLUME /usr/local/tremolo/tremolo-service/ext-lib
VOLUME /usr/local/tremolo/tremolo-service/logs


USER 431
WORKDIR /usr/local/tremolo/tremolo-service
ENV JAVA_OPTS -XX:+UseParallelGC  -Djava.security.egd=file:/dev/./urandom


CMD /usr/local/tremolo/tremolo-service/bin/firstStart.sh


#touch /usr/local/tremolo/tremolo-service/apps/proxy/auth/x && \
#touch /usr/local/tremolo/tremolo-service/conf/x && \
#touch /usr/local/tremolo/tremolo-service/apps/proxy/WEB-INF/x && \
#touch /usr/local/tremolo/tremolo-service/apps/tremolo-admin/WEB-INF/x && \
#touch /usr/local/tremolo/tremolo-service/apps/webservices/WEB-INF/x && \
