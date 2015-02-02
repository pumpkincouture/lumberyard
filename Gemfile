source 'https://rubygems.org'

gem 'datamapper'
gem 'sinatra'

group :production do
    gem "dm-postgres-adapter"
    gem "pg"
end

group :development, :test do
    gem 'sqlite3', '~> 1.3.10'
    gem "dm-sqlite-adapter"
    gem 'rack-test'
    gem 'rspec', '3.1.0'
end