source 'https://rubygems.org'

gem 'datamapper'
gem 'sinatra'
gem 'model_citizen', '~> 0.0.6'
gem 'rspec', '3.1.0'
gem 'rack-flash3'
gem 'sinatra-redirect-with-flash'

group :production do
    gem "dm-postgres-adapter"
    gem "pg"
end

group :development, :test do
    gem 'sqlite3', '~> 1.3.10'
    gem "dm-sqlite-adapter"
    gem 'rack-test'
end