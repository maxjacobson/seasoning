# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.4"

gem "pg"
gem "puma"
gem "rails"

gem "activerecord-postgres_enum"
gem "email_validator"
gem "nokogiri", ">= 1.12.5"
gem "oj_serializers"
gem "vite_rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
end

group :development do
  gem "letter_opener"
  gem "listen"
  gem "rubocop"
  gem "rubocop-rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "dry-struct"
