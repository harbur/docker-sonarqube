FROM dockerfile/java
MAINTAINER spiddy <d.kapanidis@gmail.com>

RUN echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" >> /etc/apt/sources.list
RUN apt-get update && apt-get clean ### Sonar version 5.0 - timestamp

RUN apt-get install -y --force-yes sonar=5.0
RUN curl http://repository.codehaus.org/org/codehaus/sonar-plugins/php/sonar-php-plugin/2.4/sonar-php-plugin-2.4.jar > /opt/sonar/extensions/plugins/sonar-php-plugin-2.4.jar
COPY assets/init /app/init
RUN chmod 755 /app/init
RUN chmod 755 /opt/sonar/extensions/plugins/sonar-php-plugin-2.4.jar
VOLUME /opt/sonar/extensions
VOLUME /opt/sonar/logs/

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
