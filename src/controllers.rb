=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
require 'fileutils'
require './support_files/whichos'

class Controller
	include Observer

	def initialize(view)
		self.my_view = view
		self.my_model = view.my_model
	end


	def update(model)
		self.my_model = model
	end


	def exit_app
		save
		system("clear")
		exit
	end


	def save
		Persistence.save(albums, AppData.data_storage)
		my_view.on_save
	end


	def go_back
		Breadcrumb.pop
		goto ViewStack.previous
	end


	def go_home
		Breadcrumb.clear
		goto ViewStack.last
	end


	def open(target)
		content = fetch(target)
		ViewStack.add(my_view)
		Breadcrumb.add(my_view)
		view = ViewFactory.make(content)
		view.display
	end
	

	private
	attr_accessor :my_view, :my_model

	def goto(view)
		view = my_view if view.nil?
		unregister_observers
		view.display
	end


	def unregister_observers
		my_model.remove_observer(my_view)
		my_model.remove_observer(self)
	end


	def fetch_album(name)
		album = albums.fetch_album(name)

		begin
			raise "Album does not exists" if album.nil?
		rescue Exception => e
			my_view.on_error "The Album \"#{name}\" does not exists!"
		end
		
		album
	end


	def fetch(name, type = :content)
		type_class = Object.const_get(type.capitalize)
		content = find(name, type_class)
		
		begin
			raise "#{type.capitalize} does not exists in this album!" if content.nil?
		rescue Exception => e
			my_view.on_error "The #{type.capitalize} named: \"#{name}\" does not exists in this album."
		end
		content
	end


	def find(name, type_class)
		my_model.collection.find do |content|
			content.name.eql?(name) and content.is_a?(type_class)
		end
	end


	def albums=(obj)
		@@albums ||= obj
	end


	def albums
		@@albums
	end
end



class AlbumController < Controller
	def initialize(view)
		super
		self.albums = view.my_model
	end


	def create_album(name)

		begin
			raise "Content named: #{name} already exists." unless name_unique?(name)
		rescue Exception => e
			my_view.on_error "Content named: #{name} already exists. Try a unique name next time."
		end

		album = AlbumFactory.make(name)
		my_model.add(album)
	end


	def add_media(type, name, source_path)
		begin
			raise "Content named: #{name} already exists." unless name_unique?(name)
		rescue Exception => e
			my_view.on_error "Content named: #{name} already exists. Try a unique name next time."
		end

		begin
			raise "Invalid extension for #{type.capitalize}" unless valid_extension?(type, source_path)
		rescue Exception => e
			my_view.on_error "Invalid extension for #{type.capitalize}."
		end

		attributes = persist_media_file(source_path)
		media = MediaFactory.make(type, name, attributes[:path], attributes[:extension])
		my_model.add(media)
	end


	def rename(target, name)
		begin
			raise "Content named: #{name} already exists." unless name_unique?(name)
		rescue Exception => e
			my_view.on_error "Content named: #{name} already exists. Try a unique name next time."
		end

		content = fetch(target)
		my_model.rename(content, name)
	end


	def move(target, destination)
		content = fetch(target)
		album = fetch_album(destination)
		my_model.move(content, album)
	end


	def copy(target, destination, name)
		begin
			raise "Content named: #{name} already exists." unless name_unique?(name)
		rescue Exception => e
			my_view.on_error "Content named: #{name} already exists. Try a unique name next time."
		end

		content = fetch(target)
		album = fetch_album(destination)
		my_model.copy(content, album, name)
	end


	def delete(target)
		content = fetch(target)
		my_model.delete(content)
	end


	def search(query)
		result = my_model.search(query.split(','))
		search_result = SearchResult.new(result, query)

		ViewStack.add(my_view)
		Breadcrumb.add(my_view)
		view = ViewFactory.make(search_result)
		view.display
	end

	private 

	def valid_extension?(type, path)
		type = type.to_sym.downcase
		extension = File.extname(path).downcase

		begin
			raise "#{extension} does not exists for #{type.capitalize}" unless AppData.file_extensions.has_key?(type)
		rescue Exception => e
			my_view.on_error "#{extension} does not exists for #{type.capitalize}."
		end
		
		AppData.file_extensions[type].include?(extension)
	end


	def name_unique?(name)
		find(name, Content).nil?
	end


	def persist_media_file(source_path)
		begin
			raise "File at the given path does not exists." unless File.exists?(source_path)
		rescue Exception => e
			my_view.on_error "File at the given path:#{source_path} does not exists."
		end
		
		path = AppData.file_storage
		Dir.mkdir path unless File.directory? path

		extension = File.extname(source_path)
		destination_path = path << '/'<<Time.now.getutc.to_i.to_s << extension

		FileUtils.cp(source_path, destination_path)

		{:path => destination_path, :extension => extension}
	end
end



class MediaController < Controller
	def add_keyword(keyword)
		my_model.add_keyword(keyword)
	end


	def delete_keyword(keyword)
		my_model.delete_keyword(keyword)
	end


	def execute
		file_to_open = File.absolute_path(my_model.path)
		success_msg = "The default #{my_model.class} application has been launched with the selected #{my_model.class.to_s.downcase} file."
		
		if OS.mac?
			system %{open "#{file_to_open}"}
			my_view.on_success success_msg
		elsif OS.windows?
			system %{cmd /c "start #{file_to_open}"}
			my_view.on_success success_msg
		else
			my_view.on_error "Sorry. We do not support file execution in this Operating System."
		end
	end
end



class SearchResultController < Controller
end