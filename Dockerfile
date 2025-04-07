FROM openjdk:8-jdk

ENV GLASSFISH_HOME=/usr/local/glassfish4
ENV PATH=$PATH:$GLASSFISH_HOME/bin

RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/glassfish.zip http://download.oracle.com/glassfish/4.1/release/glassfish-4.1.zip &&     unzip /tmp/glassfish.zip -d /usr/local && rm /tmp/glassfish.zip
# Admin şifresi oluşturuluyor
RUN echo "AS_ADMIN_PASSWORD=" > /opt/password.txt && \
    echo "AS_ADMIN_NEWPASSWORD=admin123" >> /opt/password.txt && \
    $GLASSFISH_HOME/bin/asadmin start-domain && \
    $GLASSFISH_HOME/bin/asadmin --user admin --passwordfile /opt/password.txt change-admin-password && \
    $GLASSFISH_HOME/bin/asadmin --user admin --passwordfile /opt/password.txt enable-secure-admin && \
    $GLASSFISH_HOME/bin/asadmin stop-domain

COPY target/ymg-jsf-maven.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/

EXPOSE 8080 4848
CMD ["asadmin", "start-domain", "--verbose"]
