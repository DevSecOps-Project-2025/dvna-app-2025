# Damn Vulnerable NodeJS Application
FROM node:20-alpine
LABEL MAINTAINER "Subash SN"

WORKDIR /app

COPY . .
RUN apk add --no-cache python3 make gcc g++
RUN chmod +x /app/entrypoint.sh \
	&& npm install

CMD ["bash", "/app/entrypoint.sh"]
