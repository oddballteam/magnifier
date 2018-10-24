# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.1'

gem 'attr_encrypted', '~> 3.0.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'graphql', '~> 1.8', '>= 1.8.10'
gem 'httparty', '~> 0.16.2'
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '>= 4.0.x'

group :development, :test do
  gem 'awesome_print', '~> 1.8'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
  gem 'rspec-rails', '~> 3.8'
	gem 'rspec_junit_formatter'
  gem 'rubocop', '~> 0.59.2', require: false
end

group :development do
  gem 'graphiql-rails', '~> 1.4', '>= 1.4.11'
  gem 'highline', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an interactive console on exception pages or by calling `console` anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.4', '>= 3.4.2'
end
