require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

sqlite_db = "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/db3.sqlite3"
DataMapper.setup(:default, sqlite_db)
# DataMapper.setup(:default, "in_memory::") # for testing purposes, no need for additional gems

class Band
	include DataMapper::Resource

	has n, :members, :model => "Musician"
	has n, :albums

	property :id, Serial
	property :name, String, :required => true
	property :genre, String #, :in => ['rock', 'blues', 'jazz', 'grunge']
	property :formed_on, Integer, :required => true # year
	property :separated_on, Time

	def self.active
		all(:separated_on => nil)
	end

end

class Musician
	include DataMapper::Resource

	belongs_to :band

	property :id, Serial
	property :first_name, String, :required => true
	property :last_name, String, :required => true

	property :instrument, String, :required => true #, :in => ['vocals', 'guitar', 'piano', 'bass', 'drums']
	property :lead_singer, Boolean

	property :nationality, String
	property :born_on, Time, :required => true
	property :died_on, Time

	def self.alive
		all(:died_on => nil)
	end

end

class Album
	include DataMapper::Resource

	belongs_to :band
	has n, :songs

	property :id, Serial
	property :name, String
	property :released_on, Time
	property :running_time, Integer # seconds
	property :type, String #, :in => ['studio', 'live', 'compilation']

end

class Song
	include DataMapper::Resource

	belongs_to :album

	property :id, Serial
	property :title, String, :required => true
	property :track_number, Integer

end

begin
	Band.count
rescue DataObjects::SyntaxError
	DataMapper.auto_migrate!
end
