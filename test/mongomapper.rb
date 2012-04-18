require 'rubygems'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('localhost')
db = MongoMapper.database = 'bowtie_test'

class Band
	include MongoMapper::Document

	many :members, :class_name => "Musician"
	many :albums

	key :name, String, :required => true
	key :genre, String, :in => ['rock', 'blues', 'jazz', 'grunge']
	key :formed_on, Integer, :required => true # year
	key :separated_on, Time

	scope :active, where(:separated_on => nil)

end

class Musician
	include MongoMapper::Document

	belongs_to :band

	key :first_name, String, :required => true
	key :last_name, String, :required => true

	key :instrument, String, :required => true, :in => ['vocals', 'guitar', 'piano', 'bass', 'drums']
	key :lead_singer, Boolean

	key :nationality, String
	key :born_on, Time, :required => true
	key :died_on, Time

	scope :alive, where(:died_on => nil)

end

class Album
	include MongoMapper::Document

	belongs_to :band
	many :songs

	key :name, String
	key :released_on, Time
	key :running_time, Integer # seconds
	key :type, String, :in => ['studio', 'live', 'compilation']

end

class Song
	include MongoMapper::Document

	belongs_to :album

	key :title, String, :required => true
	key :track_number, Integer

end
