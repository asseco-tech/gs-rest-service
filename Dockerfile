#-----------------------------------------------------------------------------------------------
FROM docker.io/fabric8/java-centos-openjdk8-jdk:latest AS BUILD
ENV TZ="Europe/Warsaw"
ENV GRADLE_URL=https://services.gradle.org/distributions/gradle-5.6.3-bin.zip

USER root
RUN yum -y install curl unzip

RUN mkdir -p /opt/gradle
WORKDIR /opt/gradle
RUN curl -L $GRADLE_URL -o gradle-bin.zip
RUN ls -la
RUN unzip gradle-bin.zip
RUN cd /opt/gradle/gradle* \
    && ln -s "$(pwd)" /usr/bin/gradle
ENV GRADLE_HOME=/usr/bin/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}
RUN gradle -v

COPY complete /var/app-src
WORKDIR /var/app-src
RUN pwd
#RUN chmod u+x gradlew
RUN gradle build -Prel
RUN ls -la build/libs/
RUN cp -p build/libs/*.jar /app.jar


#-----------------------------------------------------------------------------------------------
FROM openjdk:8-jdk-alpine
RUN apk add --no-cache tzdata bash
VOLUME /tmp
COPY --from=BUILD /app.jar /app.jar
EXPOSE 8080 8081
ENV TZ="Europe/Warsaw"
ENV JAVA_OPTS=""
ENV APP_OPTIONS="--server.port=8080"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar $APP_OPTIONS" ]
