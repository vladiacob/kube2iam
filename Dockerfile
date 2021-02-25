FROM golang:1.13-alpine as build

RUN apk add --purge --no-cache --update inotify-tools git libc-dev gcc make

RUN mkdir -p /go/src/github.com/jtblin/kube2iam

WORKDIR /go/src/github.com/jtblin/kube2iam

ENV GOARCH=amd64
ENV GOOS=linux

COPY . /go/src/github.com/jtblin/kube2iam
RUN make setup
RUN make build

FROM alpine:3.9

RUN apk --no-cache add \
    ca-certificates \
    iptables

COPY --from=build /go/src/github.com/jtblin/kube2iam/build/bin/linux/kube2iam /bin/kube2iam
RUN chmod +x /bin/kube2iam

ENTRYPOINT ["kube2iam"]
