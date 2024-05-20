FROM mcr.microsoft.com/mssql/server:latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YourStrong@Passw0rd
ENV USER=sa

# Create a directory for the app
RUN mkdir -p /usr/src/app

# Copy the initialization script and entrypoint script
COPY ./data/init.sql /usr/src/app/init-db.sql
COPY ./init/entrypoint.sh /usr/src/app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/src/app/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]