source "https://rubygems.org"

ruby file: ".ruby-version"

gem "activerecord-postgres_enum"
gem "bugsnag"
gem "dry-struct"
gem "email_validator"
gem "nokogiri"
gem "oj_serializers" # FIXME: remove oj serializers
gem "pg"
gem "puma"
gem "rails"
gem "sucker_punch"

group :development, :test do
  gem "dotenv-rails"
  gem "rspec-rails"
end

group :development do
  gem "letter_opener"
  gem "listen" # FIXME: remove this gem?
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"
end

group :test do
  gem "webmock"
end
