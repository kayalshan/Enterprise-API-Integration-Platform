FROM maven:3.9.9-eclipse-temurin-21 AS build
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /workspace
COPY pom.xml pom.xml
COPY services/pom.xml services/pom.xml
COPY services/core-api-service/pom.xml services/core-api-service/pom.xml
COPY services/core-api-service/src services/core-api-service/src
RUN mvn -f services/core-api-service/pom.xml -Dmaven.test.skip=true package

FROM eclipse-temurin:21-jre
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /app
COPY --from=build /workspace/services/core-api-service/target/core-api-service-0.1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
