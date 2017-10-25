# README #

The repository contains the necessary resources that are required for creating a docker image of Mapping Memory Manager (3M) web platform. 

The image is build upon the docker image for openjdk from [openjdk:8-jre](https://hub.docker.com/_/java/)

## 3M

The 3M is a web application suite containing several software sub-components and exploiting several external services.
Its main functionality is to assist users during the mapping definition process, using a human-friendly user interface and a set of sub-components that either suggest or validate the user input.
More information about 3M and its related components can be found at http://www.ics.forth.gr/isl/X3MLToolkit

## 3M image Building Blocks

3M Docker image is being constructed using  the docker image for jre8 from openjdk ([openjdk:8-jre](https://hub.docker.com/_/java/)).
Apart from Java 3M requires the following: 

* [eXist-DB](https://exist-db.org/) is an open source NoSQL database built on XML technology. It is classified as both a NoSQL Document database and a native XML database. eXist provides XQuery and XSLT as its query and application programming languages. 3M Docker image uses eXist-DB-2.2 which is being downloaded from bintray (https://bintray.com/artifact/download/existdb/releases/eXist-db-setup-2.2.jar)
* [Apache Tomcat](http://tomcat.apache.org/) is  is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies. 3M docker image uses Apache Tomcat 8.0.47 which is being downloaded from Apache Tomcat miror download pages (http://ftp.cc.uoc.gr/mirrors/apache/tomcat/tomcat-8/v8.0.47/bin/apache-tomcat-8.0.47.tar.gz)


## How to use

The image creates a running instance of Apache Tomcat, with the required 3M  webapps and resources allready shipped in, so that it can work as the underlying layer of 3M framework. The container starts tomcat container and listens for incoming connection at port 8080. The following environment variables are available for managing the apache tomcat container:

* IP_ADDRESS: allows the user defining the IP address (the external one) where docker is running. This will allow configuring 3M web applications with the proper external IP address they are available into. If the variable is not set when running the container, then the default IP address will be used (localhost)

To start your container using port 8080 (for 3M webapps) and 8081 (for eXistdb) using the external IP address 123.123.123.123: 

```
docker run -d -p 8080:8080 -p 8081:8081 -e IP_ADDRESS=123.123.123.123 marketak/tomcat-3m:latest
```

After running the container you can check if the instance is up and running by pasting the links below in your web browser

```
http://123.123.123.123:8080/3M
http://123.123.123.123:8081/exist
```

For maintability reasons, 3M docker image exposes the following volumes which are mounted in the filesystem where the container is running (for more infromation about the actual location of these volumes in the target filesystem use docker inspect command)
* data from eXist-DB
* tomcat folder
* 3M shared resources

### Maintainers

Yannis Marketakis (marketak 'at' ics 'dot' forth 'dot' gr)
