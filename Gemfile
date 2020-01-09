source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'rails', '~> 6.0.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '4.3.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'faker', '~> 2.7.0'
gem 'devise', '~> 4.7.1'
gem 'octicons'
gem 'octicons_helper'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug', '~> 3.7.0'
  gem 'rspec-rails', '~> 4.0.0.beta3'
  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'guard', '~> 2.16.1'
  gem 'guard-rspec'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
end

group :test do
  gem 'capybara', '~> 3.30.0'
  gem 'database_cleaner'
  gem 'webdrivers', '4.1.3'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
