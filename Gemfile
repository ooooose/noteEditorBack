source "https://rubygems.org"

ruby "3.3.6"

gem "rails", "~> 7.1.3"

gem "pg", "~> 1.4"

gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[mswin mingw x64_mingw jruby]

gem "bootsnap", require: false

gem "dotenv-rails"

gem "rack-cors"

gem "jsonapi-serializer"

gem "jwt"

gem "pundit"

gem "pagy"

gem "base64"
gem "bigdecimal"
gem "drb"
gem "logger"
gem "mutex_m"
gem "ostruct"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mswin mingw]
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 7.0.0"
  gem "simplecov", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "bullet"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "shoulda-matchers", "~> 5.0"
end
