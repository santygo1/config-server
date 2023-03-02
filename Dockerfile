FROM openjdk:17-slim as buildt

LABEL maintainer="Spirin Danil <danilkaspirin@gmail.com>"

ARG JAR_FILE

COPY ${JAR_FILE} app.jar

RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app.jar)

FROM openjdk:17-slim

VOLUME /tmp

ARG DEPENDENCY=/target/dependency
COPY --from=buildt ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=buildt ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=buildt ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java", "-cp", "app:app/lib/*", "ru.danilspirin.configserver.ConfigurationServerApplication"]