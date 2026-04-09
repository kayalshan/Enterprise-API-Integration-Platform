FROM maven:3.9.9-eclipse-temurin-21 AS build
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /workspace
COPY pom.xml pom.xml
COPY services/pom.xml services/pom.xml
COPY services/event-orchestration-service/pom.xml services/event-orchestration-service/pom.xml
COPY services/event-orchestration-service/src services/event-orchestration-service/src
RUN mvn -f services/event-orchestration-service/pom.xml -Dmaven.test.skip=true package

FROM eclipse-temurin:21-jre
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /app
COPY --from=build /workspace/services/event-orchestration-service/target/event-orchestration-service-0.1.0-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
