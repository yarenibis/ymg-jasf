FROM openjdk:8-jdk

ENV GLASSFISH_HOME=/usr/local/glassfish4
ENV PATH=$PATH:$GLASSFISH_HOME/bin

RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/glassfish.zip http://download.oracle.com/glassfish/4.1/release/glassfish-4.1.zip &&     unzip /tmp/glassfish.zip -d /usr/local && rm /tmp/glassfish.zip

COPY target/ymg-jsf-maven.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/

EXPOSE 8080 4848
CMD ["asadmin", "start-domain", "--verbose"]
