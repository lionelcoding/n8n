FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=1.88.0

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata chromium xvfb && \
    apk add --no-cache bash git openssh

# Set puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set a custom user to not have n8n run as root
USER root

# Install n8n and also temporarily all the packages it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} browserless puppeteer@21.9.0 lodash threads-api && \
    apk del build-dependencies

# Install puppeteer extra plugins
RUN npm_config_user=root npm install --location=global puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-preferences puppeteer-extra-plugin-user-data-dir

# Specifying work directory
WORKDIR /data

# define execution entrypoint
CMD ["n8n"]
