BANDS = [
	{
		:name => 'The Beatles',
		:formed_on => 1960,
		:genre => 'rock',
		:members => [{
			:first_name => 'John',
			:last_name => 'Lennon',
			:instrument => 'guitar',
			:lead_singer => true,
			:born_on => Time.mktime(1940, 10, 9),
			:nationality => 'English'
		},{
			:first_name => 'Paul',
			:last_name =>  'McCartney',
			:instrument => 'bass',
			:lead_singer => true,
			:born_on => Time.mktime(1942, 06, 18),
			:nationality => 'English'
		},{
			:first_name => 'George',
			:last_name => 'Harrison',
			:instrument => 'guitar',
			:born_on => Time.mktime(1943, 02, 25),
			:nationality => 'English'
		},{
			:first_name => 'Ringo',
			:last_name => 'Starr',
			:instrument => 'drums',
			:born_on => Time.mktime(1940, 04, 7),
			:nationality => 'English'
		}],
		:albums => [{
			:name => 'Abbey Road',
			:released_on => Time.mktime(1969, 07, 26),
			:running_time => 47, # minutes
			:type => 'studio',
			:songs => [{
				:title => 'Come Together'
				}, {
				:title => 'Something'
				}, {
				:title => "Maxwell's Silver Hammer"
				}, {
				:title => 'Oh! Darling'
				}, {
				:title => "Octopus's Garden"
				}, {
				:title => "I Want You (She's So Heavy)"
				}, {
				:title => 'Here Comes the Sun'
				}, {
				:title => 'Because See'
				}, {
				:title => 'You Never Give Me Your Money'
				}, {
				:title => 'Sun King'
				}, {
				:title => 'Mean Mr. Mustard'
				}, {
				:title => 'Polythene Pam'
				}, {
				:title => 'She Came In Through The Bathroom Window'
				}, {
				:title => 'Golden Slumbers '
				}, {
				:title => 'Carry That Weight'
				}, {
				:title => 'The End'
				}, {
				:title => 'Her Majesty'
			}]
		}]
	}
]


def add_demo_data!

	BANDS.each do |band_info|

		members = band_info.delete(:members)
		albums = band_info.delete(:albums)

		band = Band.create(band_info)

		members.each do |member_info|
			member = band.members.create(member_info)
			puts member.errors.to_a unless member.save
		end

		albums.each do |album_info|

			songs = album_info.delete(:songs)
			album = band.albums.create(album_info)

			puts album.errors.to_a unless album.save

			songs.each_with_index do |song_info, i|
				album.songs.create(song_info.merge(:track_number => i))
			end

		end

	end

end
