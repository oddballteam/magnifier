# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'

gem 'attr_encrypted', '~> 3.0.0'
gem 'coffee-rails', '~> 4.2'
gem 'httparty', '~> 0.16.2'
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'awesome_print', '~> 1.8'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '~> 0.59.2', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using
  # <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end
