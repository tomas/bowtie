require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

sqlite_db = "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/db.sqlite3"
DataMapper.setup(:default, sqlite_db) # for testing purposes, no need for additional gems
# DataMapper.setup(:default, "in_memory::") # for testing purposes, no need for additional gems

class City
  include DataMapper::Resource

	has n, :places
	has 1, :major

	property :id, Serial
	property :name, String

end

class Major
  include DataMapper::Resource

	belongs_to :city

	property :id, Serial
	property :name, String

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
  # property :food_type, String, :required => true
end

class Cinema < Place
  # property :number_of_movies, Integer  
end

DataMapper.auto_migrate!

def add_places!(city)
	# Place.delete_all
	city.places << Cinema.create(:name => "Busterblock", :address => "234 Mission St")
	city.places << Restaurant.create(:name => "Freddo's", :address => "123 Park Lane")
end

city = City.create(:name => "SF222O2222")
major = Major.create(:name => "John Lennon X")
city.major = major
major.save

add_places!(city)
