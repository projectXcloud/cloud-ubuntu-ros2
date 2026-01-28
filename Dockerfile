ARG MYAPP_IMAGE=px-ubuntu-core:latest
FROM $MYAPP_IMAGE

USER "root"
COPY install.sh /app/scripts/
RUN chmod -R 775 /app/scripts/
RUN /app/scripts/install.sh

USER "${USERNAME}"
