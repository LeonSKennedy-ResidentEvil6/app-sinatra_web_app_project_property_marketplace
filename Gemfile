source 'http://rubygems.org'

gem 'sinatra' # web application framework
gem 'activerecord', '~> 4.2', '>= 4.2.6', :require => 'active_record' # model in MVC carrying create, persis, and manipulate data objects in db
gem 'sinatra-activerecord', :require => 'sinatra/activerecord' # extension dealing with SQL database
gem 'rake' # enable using ruby code to define tasks can be run in the command line
gem 'require_all' # has all codes in the directory auto loaded
gem 'sqlite3', '~> 1.3.6' # library provides database management system
gem 'thin' # web server 
gem 'shotgun' # automatic code reloading make testing & developing easier
gem 'pry' # debugging tool
gem 'bcrypt' # secure hash algorithm handling passwords
gem 'tux' # access to database, perform and see routes and views in console
gem 'ruby-graphviz' # interface to layout and generate images
gem 'rack-flash3' # resusable flash messages
gem 'sinatra-flash' # use pop up alerting messages in sinatra
gem 'rails-erd' # generate pdf image of objects association

group :test do
  gem 'rspec' # code testing suite
  gem 'capybara' # testing tool for rack based web app simulates how user interact with a web
  gem 'rack-test' # testing API for rack app
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git' # strategies cleaning database in ruby during testing
end
