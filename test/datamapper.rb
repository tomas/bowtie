require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

sqlite_db = "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/db.sqlite3"
DataMapper.setup(:default, sqlite_db)
# DataMapper.setup(:default, "in_memory::") # for testing purposes, no need for additional gems

class City
  include DataMapper::Resource

	has n, :places
	has 1, :major

	property :id, Serial
	property :name, String, :required => true
	property :locality, String
end

class Major
	include DataMapper::Resource

	belongs_to :city

	property :id, Serial
	property :first_name, String
	property :last_name, String
end

class Place
  include DataMapper::Resource

	belongs_to :city

	property :id, Serial
	property :name, String, :required => true
	property :address, String
	property :open_on_sundays, Boolean, :default => true
	property :created_at, DateTime
end

class Restaurant < Place

end

class Cinema < Place

end

begin
	City.count
rescue DataObjects::SyntaxError
	DataMapper.auto_migrate!
end
