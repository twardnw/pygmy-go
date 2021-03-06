FROM golang:alpine as builder
LABEL stage=builder
COPY main.go /go/src/github.com/fubarhouse/pygmy-go/
COPY go.sum /go/src/github.com/fubarhouse/pygmy-go/
COPY go.mod /go/src/github.com/fubarhouse/pygmy-go/
COPY cmd/ /go/src/github.com/fubarhouse/pygmy-go/cmd/
COPY service/ /go/src/github.com/fubarhouse/pygmy-go/service/

WORKDIR /go/src/github.com/fubarhouse/pygmy-go/
RUN GO111MODULE=on GOOS=linux GOARCH=amd64 go build -o pygmy-go-linux-x86 .
RUN GO111MODULE=on GOOS=darwin GOARCH=amd64 go build -o pygmy-go-darwin .
RUN GO111MODULE=on GOOS=windows GOARCH=amd64 go build -o pygmy-go.exe .

FROM alpine
WORKDIR /app
COPY --from=builder /go/src/github.com/fubarhouse/pygmy-go/pygmy-go-darwin .
COPY --from=builder /go/src/github.com/fubarhouse/pygmy-go/pygmy-go-linux-x86 .
COPY --from=builder /go/src/github.com/fubarhouse/pygmy-go/pygmy-go.exe .
