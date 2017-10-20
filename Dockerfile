FROM openjdk:8-jre

LABEL image.maintainer="Yannis Marketakis" \
	image.organization="FORTH-ICS" \
	image.version="1.0" \
	image.lastupdate="2017-10-20" \
	image.description="Mapping Memory Manager (3M) platorm"

ENV CATALINA_HOME /opt/apache-tomcat-8.0.47
ENV PATH $CATALINA_HOME/bin:$PATH

RUN apt-get update; apt-get -y install ant ant-optional supervisor; apt-get clean 

RUN wget -q -O '/opt/exist.jar' 'https://bintray.com/artifact/download/existdb/releases/eXist-db-setup-2.2.jar' && \
    echo 'INSTALL_PATH=/opt/exist' > '/opt/options.txt' && \
    java -jar '/opt/exist.jar' -options '/opt/options.txt' && \
    rm -f '/opt/exist.jar' '/opt/options' 

ENV MAX_MEMORY 512
RUN sed -i "s/Xmx%{MAX_MEMORY}m/Xmx\${MAX_MEMORY}m/g" /opt/exist/bin/functions.d/eXist-settings.sh
# prefix java command with exec to force java being process 1 and receiving docker signals
 RUN sed -i 's/^\"${JAVA_RUN/exec \"${JAVA_RUN/'  /opt/exist/bin/startup.sh


RUN sed -i 's/8080/8081/g' /opt/exist/tools/jetty/etc/jetty.xml \
	&& sed -i 's/8080/8081/g' /opt/exist/client.properties \
	&& sed -i 's/8080/8081/g' /opt/exist/backup.properties \
	&& sed -i 's/8080/8081/g' /opt/exist/index.html

COPY Resources/3M /3M

ADD Resources/data.tar.gz /opt/exist/webapp/WEB-INF/

RUN cd /opt/ && \
	wget -q -O 'tomcat.tar.gz' 'http://ftp.cc.uoc.gr/mirrors/apache/tomcat/tomcat-8/v8.0.47/bin/apache-tomcat-8.0.47.tar.gz' && \
	tar -zxf tomcat.tar.gz && \
	rm -rf tomcat.tar.gz

ADD Resources/WARs/*.tar.gz /opt/apache-tomcat-8.0.47/webapps/

VOLUME ["/opt/exist/webapp/WEB-INF/data/","/opt/apache-tomcat-8.0.47/", "/3M/"]

ADD entrypoint.sh /entrypoint.sh
ADD supervisord-tomcat.conf /etc/supervisor/conf.d/supervisord-tomcat.conf
ADD supervisord-exist.conf /etc/supervisor/conf.d/supervisord-exist.conf

EXPOSE 8080 8081

ENTRYPOINT ["/entrypoint.sh"]
