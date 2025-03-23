FROM ruby:3.2.4-slim

RUN apt-get update \
 && apt-get -y install \
   build-essential \
   ruby-dev

RUN gem update --no-document

WORKDIR /app

CMD ["sleep", "infinity"]

