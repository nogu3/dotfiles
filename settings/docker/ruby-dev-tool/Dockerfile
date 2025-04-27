FROM ruby:3.2.7-slim

ENV GEM_HOME=/usr/local/system_gems
ENV BUNDLE_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$BUNDLE_HOME/bin:$PATH

RUN apt-get update \
 && apt-get -y install \
   build-essential \
   ruby-dev

RUN gem update --system 3.6.7 \
  && gem install \
    ruby-lsp \
    rubocop \
  && gem update --no-document

RUN mkdir -p ~/.ssh \
  && touch ~/.ssh/known_hosts \
  %% ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

WORKDIR /app

CMD ["sleep", "infinity"]

