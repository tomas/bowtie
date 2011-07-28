require 'rubygems'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('localhost')
db = MongoMapper.database = 'bowtie_test'

class City
  include MongoMapper::Document

	many :places
	one :major

	key :name, String, :required => true
end

class Major
  include MongoMapper::Document

  belongs_to :city

  key :name, String
end

class Place
  include MongoMapper::Document

	belongs_to :city

  key :name, String, :required => true
  key :address, String
  key :open_on_sundays, Boolean, :default => true
  key :created_at, Time
end

class Restaurant < Place
  # property :food_type, String, :required => true
end

class Cinema < Place
  # property :number_of_movies, Integer  
end

