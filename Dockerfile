# Multi-stage build for Java Maven project
# Stage 1: Tools image with JDK 11, JDK 8, and Trivy
FROM docker.opsbox.dev/seanly/toolset:openjdk-8-2 AS tools

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy JDK 8 from JDK 8 image
COPY --from=docker.opsbox.dev/seanly/toolset:openjdk-11 /opt/java/openjdk /opt/java/openjdk-11
RUN ln -sf /opt/java/openjdk-11 /usr/lib/openjdk-11

# Copy Trivy from custom toolset
COPY --from=docker.opsbox.dev/seanly/toolset:trivy / /

FROM docker.opsbox.dev/seanly/toolset:openjdk-8-2 

# Set working directory
WORKDIR /app

# Copy the jar file from target directory
COPY target/*.jar /app/app.jar

# Create a simple script to run the application
RUN echo '#!/bin/bash\n\
echo "Starting Java Application..."\n\
java -jar /app/app.jar\n\
echo "Application finished."' > /app/run.sh && \
chmod +x /app/run.sh

# Expose port (if needed for web applications)
EXPOSE 8080

# Default command to run the application
CMD ["/app/run.sh"] 