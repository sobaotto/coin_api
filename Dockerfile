FROM ruby:3.0.4

RUN mkdir /coin_api
WORKDIR /coin_api
COPY Gemfile /coin_api/Gemfile
COPY Gemfile.lock /coin_api/Gemfile.lock

RUN gem update --system
RUN bundle update --bundler

RUN bundle install
COPY . /coin_api

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
