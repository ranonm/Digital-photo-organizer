=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
class Content
	include Subject
	attr_reader :name, :timestamp

	def initialize(name)
		init_subject
		self.name = name
		@timestamp = Time.now.getutc
	end


	def name=(name)
		@name = name
	end


	def name
		@name
	end
end



class Album < Content
	attr_reader :collection

	def initialize(name)
		super(name)
		@collection = []
	end


	def add(content)
		@collection << content
		notify_observers
	end


	def delete(content)
		collection.delete(content)
		notify_observers
	end


	def move(content, destination)
		obj = collection.delete(content)
		destination.add(obj) unless obj.nil?
		notify_observers
	end


	def copy(content, destination, new_name)
		obj = content.dup if collection.include?(content)
		obj.name = new_name
		destination.add(obj)
		notify_observers
	end


	def rename(content, new_name)
		content.name = new_name
		notify_observers
	end


	def search(words)
		results = []
		collection.each do |content|
			result = content.search(words)
			results << result unless result.nil?
		end
		results
	end


	def match_name?(name)
		self.name.eql? name
	end


	def fetch_album(name)
		if match_name?(name)
			album = self
		else
			collection.each do |content|
				if content.respond_to?(:fetch_album)
					album = content.fetch_album(name)
					break album if album.is_a? self.class
				end
			end
		end
		album
	end
end



class Media < Content
	attr_reader :keywords, :path, :extension

	def initialize(name)
		super(name)
		@keywords = []
	end


	def path=(path)
		@path = path
	end


	def extension=(ext)
		@extension = ext
	end


	def add_keyword(word)
		@keywords << word
		notify_observers
	end


	def delete_keyword(word)
		@keywords.delete(word)
		notify_observers
	end


	def modify_keyword(word, new_word)
		index = keywords.index(word)
		return nil if index.nil?

		keywords[index] = new_word
		notify_observers
	end


	def has_keyword?(word)
		keywords.include?(word)
	end


	def search(words)
		words.each do |word|
			return self if has_keyword?(word)
		end
		nil
	end
end


class Photo < Media
end


class SearchResult
	include Subject
	attr_reader :name, :collection

	def initialize(contents, query)
		init_subject
		@collection = contents.flatten
		@name = "Search results for: #{query}"
	end
end