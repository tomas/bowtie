current_path = File.expand_path(File.dirname(__FILE__))

adapter = ENV['ADAPTER'] || 'mongomapper'

require current_path + "/#{adapter}"
require current_path + '/demo_data'
require current_path + '/../lib/bowtie'

add_demo_data! if City.count == 0

map "/admin" do
	# BOWTIE_AUTH = {:user => 'admin', :pass => 'secret'}
	run Bowtie::Admin
end
