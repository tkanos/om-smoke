FROM golang:1.14 as builder

WORKDIR /go/src/github.com/checkr/
RUN git clone https://github.com/checkr/openmock.git /go/src/github.com/checkr/openmock
WORKDIR /go/src/github.com/checkr/openmock
RUN make build

RUN git clone https://github.com/bluehoodie/smoke.git /go/src/github.com/bluehoodie/smoke
WORKDIR /go/src/github.com/bluehoodie/smoke
RUN CGO_ENABLED=0 GOOS=linux go build -o smoke .

FROM alpine:latest
WORKDIR /bin
RUN apk add --no-cache ca-certificates libc6-compat
COPY --from=builder /go/src/github.com/checkr/openmock/om /bin/om
COPY --from=builder /go/src/github.com/bluehoodie/smoke/smoke /bin/smoke
ENV OPENMOCK_HTTP_HOST=0.0.0.0
ENV OPENMOCK_TEMPLATES_DIR=/data/templates
