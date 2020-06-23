# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~>5.2"
# Use sqlite3 as the database for Active Record
gem "sqlite3"


# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"


# Use ActiveModel has_secure_password
gem "bcrypt", git: "https://github.com/codahale/bcrypt-ruby.git", require: "bcrypt"

# Image manipulation
gem "mini_magick"

# Devise with security-extension for User Authentication with Captcha
gem "devise", "~> 4"
gem "devise-i18n"

# Testing
gem "rspec-rails"
# gem 'rails_helper', '~> 2.2', '>= 2.2.2'

# Bootstrap
gem "bootstrap"
gem "jquery-rails"

# jQuery UI
gem "jquery-ui-rails"

# rubyzip
gem "rubyzip", "~> 2.3"

# Fontawesome
gem "font-awesome-sass", "~>5.13"

# Internationalization Data
gem "rails-i18n"

# Easier routing for internationalization
gem "routing-filter"

# Form helper
gem "dynamic_form"

# Text extraction from Apache Tika compatible files
gem "henkei"


# Active Record Pagination
gem "will_paginate"
gem "bootstrap-will_paginate"

# Browser language detection
gem "http_accept_language"

# Easy cloning of active_record objects including associations and several operations under associations and attributes.
gem "amoeba"

group :production do
# Use Redis adapter to run Action Cable in production
  gem "redis"
# Use postgreSQL as database for Active Record
  gem "pg"
# See https://github.com/rails/execjs#readme for more supported runtimes
  gem "therubyracer", platforms: :ruby
end


# Use Capistrano for deployment
group :development do
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rvm"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.13"
  gem "rails-erd"
  gem "rubocop-rails"
  gem "selenium-webdriver"
  gem "yard"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
