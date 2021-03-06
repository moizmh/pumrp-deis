FROM tomcat:9

MAINTAINER juliens@microsoft.com

#need to add steps to build the war file from the source code
# Gradle
#https://github.com/niaquinto/docker-gradle/blob/master/Dockerfile

ENV GRADLE_VERSION 3.3
ENV GRADLE_SHA c58650c278d8cf0696cab65108ae3c8d95eea9c1938e0eb8b997095d5ca9a292

RUN cd /usr/lib \
 && curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && echo "$GRADLE_SHA gradle-bin.zip" | sha256sum -c - \
 && unzip "gradle-bin.zip" \
 && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
 && rm "gradle-bin.zip"

# Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/lib/gradle
ENV PATH $PATH:$GRADLE_HOME/bin


ADD . /client
RUN cd /client && gradle build && dir && mv build/libs/* /usr/local/tomcat/webapps/

#RUN dir /usr/local/tomcat/webapps/

#COPY .Web/build/libs/* /usr/local/tomcat/webapps/

EXPOSE 8080

ENTRYPOINT catalina.sh run