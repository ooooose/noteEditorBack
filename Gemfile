source "https://rubygems.org"

ruby "3.3.5"

gem "rails", "~> 7.1.3"

gem "pg", "~> 1.4"

gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[windows jruby]

gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "dotenv-rails"

gem "rack-cors"

gem "jsonapi-serializer"

gem "jwt"

gem "base64"
gem "bigdecimal"
gem "drb"
gem "logger"
gem "mutex_m"
gem "ostruct"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 7.0.0"
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
