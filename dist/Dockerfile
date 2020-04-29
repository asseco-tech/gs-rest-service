FROM docker.io/fabric8/java-centos-openjdk8-jdk:latest
VOLUME /tmp
COPY rest-service-0.0.1.jar /app.jar
EXPOSE 8080
ENV TZ="Europe/Warsaw"
ENV JAVA_OPTS=""
ENV APP_OPTIONS="--server.port=8080"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar $APP_OPTIONS" ]
