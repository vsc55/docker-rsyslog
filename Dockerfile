FROM alpine:3.7

MAINTAINER Javier Pastor <vsc55@cerebelum.net>
LABEL version="1.0" maintainer="vsc55@cerebelum.net" description="Server rSyslog + MySQL"


RUN apk upgrade --no-cache; \
    apk add --no-cache bash curl rsyslog rsyslog-mysql;
	
WORKDIR /

COPY --chown=root:root ["entrypoint.sh", "run_srv.sh", "health_check.sh", "./"]

#Fix, hub.docker.com auto buils
RUN chmod +x /*.sh


ENV MYSQL_HOST="" MYSQL_PORT="" MYSQL_DB="" MYSQL_USER="" MYSQL_PASS=""


ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]


#Volume's
VOLUME ["/var/log"]


#Port's
EXPOSE 514/tcp
EXPOSE 514/udp


HEALTHCHECK --interval=5s --timeout=3s CMD /health_check.sh
