FROM node:14-alpine

WORKDIR /app
COPY . .

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk update && \
    apk add --update python3 openssl && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
    apk add --update python3-dev build-base linux-headers && \
    pip3 install sparkfun-ublox-gps pyserial spidev && \
    npm install
EXPOSE 4840/tcp

ENTRYPOINT ["npm", "--no-update-notifier", "--no-fund", "start", "--cache", "/app/data/.npm"]
