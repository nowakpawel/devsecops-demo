FROM eclipse-temurin:21-jre-alpine
RUN apk upgrade --no-cache openssl
WORKDIR /app
COPY target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]