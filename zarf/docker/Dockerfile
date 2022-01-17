FROM golang:1.16-alpine3.13 AS builder

RUN apk --no-cache add ca-certificates make

RUN update-ca-certificates

ARG goflags="-tags=release"
ENV GOFLAGS=$goflags

ENV GO111MODULE=on
ENV CGO_ENABLED=0

WORKDIR /src
COPY . .

RUN make build-go

FROM scratch AS api
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /src/tmp/api /api
EXPOSE 3000
EXPOSE 4000
ENTRYPOINT ["/api"]
