=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
class Persistence
	class << self
		def save(obj, filename)
			serialized = Marshal.dump(obj)

			directory = File.dirname(filename)
			Dir.mkdir directory unless File.directory? directory

			file = File.open(filename, 'w')
			file.puts serialized
			file.close
		end


		def restore(filename)
			obj = nil
			if exists?(filename)
				file = File.open(filename, 'r')
				obj = Marshal.load(file)
				file.close
			end
			obj
		end


		def exists?(filename)
			File.exists?(filename)
		end
	end
	
	private_class_method :new
end