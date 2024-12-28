# Stage 1: Build the application with Maven
FROM docker.io/library/maven:latest AS maven_builder
WORKDIR /build
COPY . .
RUN mvn verify

# Stage 2: Deploy the application to Tomcat
FROM docker.io/library/tomcat:latest
COPY --from=maven_builder /build/target/java-tomcat-maven.war /usr/local/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat 
CMD ["catalina.sh", "run"]