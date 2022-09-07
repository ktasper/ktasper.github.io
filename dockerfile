FROM golang:1.18 as builder
ARG HUGO_VERSION=v0.97.3
RUN git clone https://github.com/gohugoio/hugo.git /go/src/hugo
WORKDIR /go/src/hugo
RUN git checkout ${HUGO_VERSION}
RUN CGO_ENABLED=1 go build --tags extended


FROM ubuntu:20.04
COPY --from=builder /go/src/hugo /usr/local/bin
# Setup container to expose port and where to look for files
EXPOSE 1313
VOLUME /app
WORKDIR /app
# Start the hugo server which is made available to localhost:1313
CMD ["hugo", "server", "--disableFastRender", "--bind=0.0.0.0"]
