# Damn Vulnerable NodeJS Application
# Damn Vulnerable NodeJS Application
FROM node:20-alpine 

LABEL MAINTAINER "Subash SN"

WORKDIR /app

COPY . .

RUN apk update \
    && apk add --no-cache build-base python3

RUN chmod +x /app/entrypoint.sh \
    && npm install

CMD ["bash", "/app/entrypoint.sh"]
