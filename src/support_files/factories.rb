=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
module ContentFactory
	def make
		raise NotImplementedError, "The make method needs to be implemented."
	end
end



class MediaFactory
	include ContentFactory

	def self.make(type, name, path, extension)
		type.capitalize!
		if Object.const_defined?(type) and Object.const_get(type).superclass.eql? Media
			type_class = Object.const_get(type)
		else
			raise "Media type does not exists"
		end

		media = type_class.new(name)
		media.path = path
		media.extension = extension

		media
	end
end


class AlbumFactory
	include ContentFactory

	def self.make(name)
		Album.new(name)
	end
end


class ViewFactory
	def self.make(model)
		type = model.class.superclass.eql?(Media) ? "MediaView" : model.class.to_s.concat("View")
		if Object.const_defined?(type) and Object.const_get(type).superclass.eql? View
			type_class = Object.const_get(type)
		else
			raise "View type does not exists"
		end
		type_class.new(model)
	end
end