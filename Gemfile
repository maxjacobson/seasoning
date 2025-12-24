source "https://rubygems.org"

ruby file: ".ruby-version"

gem "activerecord-session_store"
gem "bcrypt"
gem "bugsnag"
gem "cssbundling-rails"
gem "dry-struct"
gem "email_validator"
gem "jsbundling-rails"
gem "kramdown"
gem "kramdown-parser-gfm"
gem "nokogiri"
gem "ostruct"
gem "pg"
gem "propshaft"
gem "puma"
gem "rails", github: "rails", branch: "main"
gem "rails_autolink"
gem "sucker_punch"
gem "turbo-rails"

group :development, :test do
  gem "dotenv-rails"
end

group :development do
  gem "erb_lint"
  gem "letter_opener"
  gem "listen"
  gem "rubocop"
  gem "rubocop-capybara"
  gem "rubocop-minitest"
  gem "rubocop-rails"
end

group :test do
  gem "capybara"
  gem "capybara-playwright-driver"
  gem "minitest-mock", require: "minitest/mock"
  gem "simplecov", require: false
  gem "webmock"
end
