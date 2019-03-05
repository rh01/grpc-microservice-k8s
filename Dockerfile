FROM golang AS build-env
ADD . /go/src/app
WORKDIR /go/src/app

ENV http_proxy http://192.168.1.9:12333
ENV https_proxy http://192.168.1.9:12333

RUN go get -u -v github.com/kardianos/govendor && go get -u -v github.com/kardianos/govendor
RUN govendor sync
RUN GOOS=linux GOARCH=arm GOARM=7 go build -v -o /go/src/app/gcd-server

# Change this path!
WORKDIR /go/src/github.com/tinrab/kubernetes-go-grpc-tutorial/api
COPY api .
COPY pb ../pb

RUN go get -v ./...
RUN go install -v ./...

EXPOSE 3000

CMD [ "api" ]