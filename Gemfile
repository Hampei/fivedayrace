source 'https://rubygems.org'

gem 'rails', '3.2.1'
gem 'thin'
gem 'sinatra'

# last commit before it started using EventMachine v1
# heroku doesn't support EMv1 yet.
gem "simple_oauth", "~> 0.1.7"
gem 'em-http-request', git: 'https://github.com/hampei/em-http-request.git', branch: 'em0.12.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'fitgem', :git => 'https://github.com/whazzmaster/fitgem.git'
gem 'omniauth-fitgem', :git => 'https://github.com/hampei/omniauth-fitgem.git', :branch => 'fix-gemspec'

gem 'apn_on_rails'

gem 'haml-rails'
gem 'redis'
gem 'less-rails'

group :development do
  gem 'sqlite3'
  gem 'heroku'
end

group :test do
  gem 'fabrication'      , '~> 1.2.0'
  gem 'rspec-rails'      , '~> 2.8.0'
end

group :production do
  gem 'mysql2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
