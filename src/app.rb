=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
require "./config/settings"
require "./support_files/utilities"
require "./support_files/breadcrumb"
require "./support_files/observer"
require "./support_files/subject"
require "./support_files/viewstack"
require "./support_files/factories"
require "./support_files/persistence"
require "./models"
require "./views"
require "./controllers"


class App
	extend Utilities
	
	class << self
		def run 
			view = ViewFactory.make library
			view.display
		end


		def library
			if first_time?
				puts "It is your first time using PIXBox, Welcome!"
				name = ask "Please give your Root album a name:"
				albums = AlbumFactory.make(name)
			else
				albums = Persistence.restore(AppData.data_storage)
			end
			return albums
		end


		def first_time?
			data = Persistence.restore(AppData.data_storage)
			return (not(data.is_a? Album) or data.nil?) ? true : false
		end
	end

	private_class_method :new, :library, :first_time?
end

App.run