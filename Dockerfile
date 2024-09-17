FROM ruby:3.3.1
ENV TZ Asia/Tokyo
ENV RAILS_ENV=development

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    default-mysql-client

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
