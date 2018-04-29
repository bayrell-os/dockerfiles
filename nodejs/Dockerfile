FROM node:9.5-alpine

RUN echo "[1] Install system components"; \
    apk update; \
    apk add bash git curl nano mc; \
    npm install bower -g --allow-root; \
