source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

# ==============

# !!! ADDED TO CHANGE IN PRODUCTION TO postgresql IN ORDER TO BE ABLE TO DEPLOY INTO HEROKU !!!
group :production do
	gem 'pg', '~> 0.18.0'
end

# To be able to bundle install the pg gem, I had to download from http://postgresapp.com
# the Postgres.app and added it to the applications folder
# Then ran:
# =>  gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config 

# For iMac I had to use:
# $ sudo su
# $ env ARCHFLAGS="-arch x86_64" gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config

#-------------

gem 'rails_12factor', group: :production

# ==============

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc



# Added during the course:

# GEM used to manage login
gem 'devise'
# Simple_Form to configure forms
gem 'simple_form'

gem 'state_machine'

gem 'draper'




# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

group :development, :test do 
	# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
end

group :test do
	gem 'shoulda'
	gem 'factory_girl_rails'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

