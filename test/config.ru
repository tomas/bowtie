current_path = File.expand_path(File.dirname(__FILE__))

adapter = ARGV[1] || 'datamapper'

require current_path + "/#{adapter}"
require current_path + '/../lib/bowtie'

app = Rack::Builder.new {

	# BOWTIE_AUTH = {:user => 'admin', :pass => 'secret'}

	map "/admin" do
		run Bowtie::Admin
	end
}

run app
