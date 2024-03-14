# Stage 1: Build the Java application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package


# Stage 2: Create a smaller runtime container
# Use an official OpenJDK runtime as a base image
FROM openjdk:17

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.war ./app.war

#COPY target/demo-0.0.1-SNAPSHOT.war /app/demo-0.0.1-SNAPSHOT.war

# Expose the port your application runs on
EXPOSE 8081

# Specify the command to run your application
CMD ["java", "-jar", "app.war"]
