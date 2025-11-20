FROM eclipse-temurin:21.0.9_10-jdk-noble AS build

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN ./mvnw -q dependency:go-offline

COPY src src

RUN ./mvnw clean package -DskipTests


FROM eclipse-temurin:21.0.9_10-jre-noble AS RUN

RUN groupadd -g 1001 spring && \
    useradd -u 1001 -g spring -M -s /usr/sbin/nologin spring


WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

RUN chown -R spring:spring /app

USER spring

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]

