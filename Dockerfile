FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       python3 \
       python3-pip \
       cron \
       curl

# Clean up to reduce container size
RUN rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/cron.*/*

# Install Python libraries
RUN pip3 install requests psycopg2-binary pandas

# Copy your Python script and other necessary files into the container
COPY DEV_EOD_Stock_Email.ipynb /app/DEV_EOD_Stock_Email.ipynb
COPY crontab /etc/cron.d/hello-cron
COPY entrypoint.sh /entrypoint.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Give execution rights on the script
RUN chmod +x /app/your_script.py
RUN chmod +x /entrypoint.sh

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron", "-f", "-L", "2"]
