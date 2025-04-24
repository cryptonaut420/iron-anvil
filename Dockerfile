# Use Debian Bullseye as base image with Node.js
FROM node:18-bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    supervisor \
    cron \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash
# Initialize foundryup to install Foundry tools
RUN /root/.foundry/bin/foundryup

# Add foundry binaries to PATH
ENV PATH="/root/.foundry/bin:${PATH}"

# Create directories
RUN mkdir -p /app/data

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY crontab /etc/cron.d/anvil-cron
COPY start-anvil.sh /app/start-anvil.sh
COPY save-state.sh /app/save-state.sh

# Make scripts executable
RUN chmod +x /app/start-anvil.sh /app/save-state.sh

# Setup cron job permissions
RUN chmod 0644 /etc/cron.d/anvil-cron
RUN crontab /etc/cron.d/anvil-cron

# Expose the Anvil port
EXPOSE 8545

# Start supervisord as the main process
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 