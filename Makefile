build:
  docker build -f Dockerfile.alpine . -t codecraft:alpine

build-nc:
  docker build -f Dockerfile.alpine . -t codecraft:alpine --no-cache
