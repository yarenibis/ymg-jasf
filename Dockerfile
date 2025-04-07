FROM openjdk:8-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV GLASSFISH_HOME=/usr/local/glassfish4
ENV PATH=$PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin

RUN apt-get update &&     apt-get install -y curl unzip zip inotify-tools &&     rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/glassfish-4.1.zip http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip &&     unzip /tmp/glassfish-4.1.zip -d /usr/local &&     rm -f /tmp/glassfish-4.1.zip

RUN mkdir -p web/WEB-INF/classes
COPY src/java/com/example/bean/UserInfoBean.java src/java/com/example/bean/UserInfoBean.java

RUN find $GLASSFISH_HOME/glassfish/modules -name "*.jar" > /tmp/cp.txt &&     export CP=$(paste -sd: /tmp/cp.txt) &&     javac -cp "$CP" -d web/WEB-INF/classes src/java/com/example/bean/UserInfoBean.java

COPY web/ $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/jsf-app/

EXPOSE 8089 4848

WORKDIR /usr/local/glassfish4
CMD ["asadmin", "start-domain", "--verbose"]
