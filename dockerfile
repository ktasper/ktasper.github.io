# Stable Slim
FROM debian:latest

ENV HUGO_VERSION 0.97.3

ENV HUGO_SHA256 e0f95508ee9366750a33c1a87dc6fd1a5229536c017026074e954b21780033cb

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb /tmp/hugo.deb

# Make sure checksum matches
RUN echo ${HUGO_SHA256}  /tmp/hugo.deb | sha256sum -c -
# Install Hugo & remove install package
RUN dpkg -i /tmp/hugo.deb && rm /tmp/hugo.deb


# Setup container to expose port and where to look for files
EXPOSE 1313
VOLUME /app
WORKDIR /app

# Start the hugo server which is made available to localhost:1313
CMD ["hugo", "server", "--disableFastRender", "--bind=0.0.0.0"]