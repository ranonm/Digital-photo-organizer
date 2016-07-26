=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
require "./config/appdata"

module Settings
	include AppData
	AppData.config do
		data_storage 'data/albums.dat'
		file_storage 'media'
		file_extensions({:photo => ['.jpeg', '.png', '.jpg']})
	end
end
