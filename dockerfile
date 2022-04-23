# Stable Slim
FROM debian:latest

ENV HUGO_VERSION 0.97.3

ENV HUGO_SHA256 019d3397f672a85eb821ceb716c4684591ea796ba2980eb2ddd19bcf519faad8

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_ARM64.deb /tmp/hugo.deb

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