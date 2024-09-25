FROM ruby:3.2

RUN apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get install --assume-yes build-essential libpq-dev nodejs graphviz postgresql-contrib redis-tools

ENV app /notifications-api

RUN mkdir $app
WORKDIR $app

ENV BUNDLE_PATH /ruby-bundle

ADD . $app
