FROM node:11.6.0-alpine AS builder
WORKDIR /app
COPY ./ ./
RUN node --version && npm --version && npm install 
RUN npm run build

FROM node:11.6.0-alpine
WORKDIR /var/www
COPY --from=builder /app/dist/index.js /var/www/index.js
CMD [ "/var/www/index.js" ]
ENTRYPOINT [ "node" ]
