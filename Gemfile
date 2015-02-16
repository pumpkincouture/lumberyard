source 'https://rubygems.org'

gem 'datamapper'
gem 'sinatra'
gem 'model_citizen', '~> 0.0.5'
gem 'rspec', '3.1.0'

group :production do
    gem "dm-postgres-adapter"
    gem "pg"
end

group :development, :test do
    gem 'sqlite3', '~> 1.3.10'
    gem "dm-sqlite-adapter"
    gem 'rack-test'
end