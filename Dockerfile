FROM python:3.8-alpine

WORKDIR /app
COPY . .

RUN apk update && apk add python3-dev build-base linux-headers
RUN pip3 install sparkfun-ublox-gps pyserial spidev
RUN apk add --update nodejs npm
RUN npm install
EXPOSE 4840/tcp

ENTRYPOINT ["npm", "--no-update-notifier", "--no-fund", "start", "--cache", "/app/data/.npm"]
