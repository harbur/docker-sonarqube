FROM dockerfile/java
MAINTAINER spiddy <d.kapanidis@gmail.com>

RUN echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" >> /etc/apt/sources.list
RUN apt-get update && apt-get clean

RUN apt-get install -y --force-yes sonar=4.5.1

COPY assets/init /app/init
RUN chmod 755 /app/init

VOLUME /opt/sonar/extensions
VOLUME /opt/sonar/logs/

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
