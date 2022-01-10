FROM ruby:3.1.0

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update -qq && apt-get install -y build-essential nodejs yarn --no-install-recommends vim logrotate cron

ENV LANG C.UTF-8

RUN mkdir /react_test_app
WORKDIR /react_test_app
COPY Gemfile /react_test_app/Gemfile
COPY Gemfile.lock /react_test_app/Gemfile.lock
COPY ./docker/db/my.cnf /etc/mysql/conf.d/my.cnf
COPY ./docker/log/logrotate.conf /etc/logrotate.conf
COPY ./docker/log/rails /etc/logrotate.d/rails
RUN chmod 644 /etc/mysql/my.cnf
RUN bundle config --local build.mysql2 "--with-cppflags=-I/usr/local/opt/openssl/include"
RUN bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib"
RUN chmod 644 /etc/logrotate.d/rails
RUN chown root:root /etc/logrotate.d/rails
RUN bundle install
COPY . /react_test_app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 80

# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]

# cron
# CMD ["cron", "-f"]
