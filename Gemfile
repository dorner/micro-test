source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'sprockets-es6', '>= 0.9'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 6.0'
gem "select2-rails", '~> 4.0'

gem 'will_paginate', '~> 3.1'


# AWS libraries
gem 'aws-sdk-rails', '~> 1.0'
# for Elastic Beanstalk
 gem 'active_elastic_job', git: 'https://github.com/dorner/active-elastic-job.git',
    tag: 'v2.0.2.flipp'


# Mass import of records
gem 'activerecord-import', '~> 0.17'


# For SSO authentication
gem 'rubycas-client', :git => 'https://github.com/lenardp/rubycas-client.git'

gem 'activerecord-session_store', '~> 1.0'


group :production, :staging do
  gem 'ddtrace', '~> 0.7.0', require: false
end

group :development, :test do
  gem 'spring', '~> 2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', '~> 0.49.1', require: false
  gem 'rubocop-rspec', '~> 1.15', require: false
end

group :test do

  gem 'database_cleaner', '~> 1.5'
  gem 'factory_girl', '~> 4.8'

  gem 'rspec-rails', '~> 3.5'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'pronto', '~> 0.9', require: false
  gem 'pronto-rubocop', require: false,
                        git: 'https://github.com/dorner/pronto-rubocop.git',
                        tag: 'v0.9.1.flipp'
end

group :development do

  gem 'annotate', '~> 2.6.5'

  gem 'better_errors', '~> 2.1'
  gem 'binding_of_caller', '~> 0.7'
end

