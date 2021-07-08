FROM node:lts-alpine

WORKDIR /app
COPY . .

RUN npm install && pip3 install --upgrade pip && pip3 install sparkfun-ublox-gps pyserial spidev
EXPOSE 4840/tcp

ENTRYPOINT ["npm", "--no-update-notifier", "--no-fund", "start", "--cache", "/app/data/.npm"]
