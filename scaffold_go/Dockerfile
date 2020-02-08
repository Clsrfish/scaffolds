FROM golang:1.11-alpine3.8 AS builder
ARG ARG_PKG=weixin-service
ARG ARG_DOMAIN=github.com/yahdude
WORKDIR $GOPATH/src/${ARG_PKG}
COPY ./src ./
ENV GO111MODULE=on CGO_ENABLED=0 GOPROXY=https://goproxy.io 
RUN go mod tidy
RUN go install -a -v -work ${ARG_DOMAIN}/${ARG_PKG}
RUN mv $GOPATH/bin/${ARG_PKG} /go/main

FROM alpine:3.8
WORKDIR /var/www
COPY --from=builder /go/main /var/www/main
COPY ./src/conf.yaml /var/www/conf.yaml
COPY ./src/weixin_codes.json /var/www/weixin_codes.json
ENTRYPOINT [ "/var/www/main" ]
