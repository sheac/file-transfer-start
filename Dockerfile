FROM ruby:2.4.1

# postgres deps
RUN apt-get update \
  && apt-get install -y postgresql postgresql-contrib \
  && apt-get install sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# app location
RUN mkdir -p app
WORKDIR app

# install gems
COPY ./Gemfile ./
COPY ./install_gems.sh ./
RUN ./install_gems.sh

COPY ./docker-utils ./docker-utils
ENTRYPOINT ["./docker-utils/entrypoint.sh"]