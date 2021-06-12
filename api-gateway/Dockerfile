FROM maven:3.5-jdk-8-alpine AS builder
COPY src /api-gateway/src
COPY pom.xml /api-gateway
RUN mvn -f /api-gateway/pom.xml clean package

ENV LOGIC_API_URL http://localhost:5000

FROM openjdk:8-jre-alpine
COPY --from=builder /api-gateway/target/gateway-0.0.1-SNAPSHOT.jar ./
EXPOSE 8080
CMD ["java", "-jar", "gateway-0.0.1-SNAPSHOT.jar", "--glo4008.logic.api.url=${LOGIC_API_URL}"]