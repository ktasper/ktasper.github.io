# Stable Slim
FROM debian:latest

ENV HUGO_VERSION 0.97.3

ADD https://github.com/gohugoio/hugo/releases/download/v0.97.3/hugo_0.97.3_Linux-ARM64.deb /tmp/hugo.deb


# Install Hugo & remove install package
RUN dpkg -i /tmp/hugo.deb && rm /tmp/hugo.deb


# Setup container to expose port and where to look for files
EXPOSE 1313
VOLUME /app
WORKDIR /app

# Start the hugo server which is made available to localhost:1313
CMD ["hugo", "server", "--disableFastRender", "--bind=0.0.0.0"]