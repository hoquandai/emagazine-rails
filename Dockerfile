FROM ruby:2.6.3

RUN apt-get update -qq && \
  apt-get install -y \
  apt-utils \
  build-essential \
  nodejs \
  default-libmysqlclient-dev \
  vim nano \
  cron \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt update && apt install yarn

ENV RAILS_ROOT /app

RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile* ./
RUN gem install bundler
RUN gem install mysql2

ARG RAILS_MASTER_KEY=""
RUN test -z "$RAILS_MASTER_KEY" || bundle config set without 'development test'
RUN bundle install -j 20 -r 5

COPY yarn.lock package.json ./
RUN yarn install

COPY . $RAILS_ROOT

RUN test -z "$RAILS_MASTER_KEY" || RAILS_ENV=production rake assets:precompile

ARG REVISION=""
RUN echo $REVISION > REVISION

EXPOSE 3000 80

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
