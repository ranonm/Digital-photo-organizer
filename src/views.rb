=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
require "./support_files/textdecor"

module ContainableView
	def cmd_open
		target = ask "Select content (enter content name):"
		my_controller.open(target)
	end
end



class View
	include Observer, Utilities

	attr_reader :my_model

	def initialize(model)
		self.my_model = model
		self.my_controller = make_controller
		register_observers
	end


	def register_observers
		my_model.add_observer(self)
		my_model.add_observer(my_controller)
	end


	def update(model)
		self.my_model = model
		display
	end


	def display
		system("clear")
		puts header
		puts body
		puts "\n\n\n"
		puts menu
		prompt_for_command
	end


	def menu
		output = "Available commands:\n\n"
		line_cnt = 1
		menu_options.each do |command, desc|
			line = command.to_s.green << " : " << desc
			line = line_cnt.odd? ? sprintf("%-50s", line) : sprintf("%s\n",line)
			output << line
			line_cnt+=1
		end
		output << "\n\n"
	end


	def prompt_for_command
		begin
			cmd = "cmd_" << ask("Select a command:")
			on_error "This command does not exists" unless valid = self.respond_to?(cmd, true)
		end until valid

		self.send cmd
	end


	def body
		raise NotImplementedError, "The body method needs to be implemented."
	end


	def header
		output = "PIXBox".bold.center(80).concat("\n")
		output << "you are in: #{Breadcrumb.output} #{my_model.name.underline}"
		output << "\n\n\n"
		output
	end


	def menu_options
		{
			:home => "Go to the root album",
			:back => "Go back to the previous album",
			:exit => "Exit application",
		}
	end


	def on_save
		system_msg("Saving albums and media to library...")
	end


	def on_error(message)
		system_msg(message, :error)
		display
	end


	def on_success(message)
		system_msg(message, :success)
		display
	end


	private
	attr_accessor :my_controller


	def content_tabular_display(empty_msg = "No content available.")
		if my_model.collection.empty?
			output = empty_msg
		else
			output = sprintf("%-20s %-20s %s\n\n", "NAME", "CONTENT TYPE", "TIMESTAMP")
			my_model.collection.each do |content|
				output << sprintf("%-20s %-20s %s\n", content.name, content.class.to_s, content.timestamp.to_s)
			end
		end
		output
	end


	def my_model=(model)
		@my_model = model
	end


	def make_controller
		raise NotImplementedError, "This method needs to be implemented."
	end


	def cmd_home
		my_controller.go_home
	end


	def cmd_back
		my_controller.go_back
	end


	def cmd_exit
		if confirm "Are you sure you want to exit?"
			system_msg "Good bye!"
			my_controller.exit_app
		else
			display
		end
	end
end



class AlbumView < View
	include ContainableView

	def body
		content_tabular_display
	end


	private

	def make_controller
		AlbumController.new(self)
	end


	def menu_options
		{   
			:open => "Open an album or photo",
			:create => "Create a new album",
			:add => "Add photo to current album",
			:rename => "Change the name of an album or photo",
			:move => "Move an album or a photo",
			:copy => "Copy and album or a photo",
			:delete => "Delete an album or a photo",
		}.merge(super)
	end


	def cmd_create
		name = ask "Album name (must be unique):"
		my_controller.create_album(name)
	end


	def cmd_add
		name = ask "Photo's name (must be unique):"
		path = ask "Absolute path to the photo file:"
		my_controller.add_media("Photo", name, path)
	end


	def cmd_rename
		target = ask "Select content (enter content name):"
		new_name = ask "Rename to (must be unique):"
		my_controller.rename(target, new_name)
	end


	def cmd_move
		target = ask "Select content (enter content name):"
		destination = ask "Move to album:"
		my_controller.move(target, destination)
	end


	def cmd_copy
		target = ask "Select content (enter content name):"
		destination = ask "Copy to album:"
		new_name = ask "As (new name must be unique):"
		my_controller.copy(target, destination, new_name)
	end


	def cmd_delete
		target = ask "Select content to be deleted (enter content name):"
		my_controller.delete(target) if confirm "Are you sure you want to delete the selected content?"
	end


	def cmd_search
		query = ask "Enter a comma-separated list of keywords you want to search with:"
		my_controller.search(query) unless query.strip.empty?
	end
end


class MediaView < View
	def body
		output = sprintf("%-20s %s\n", "NAME:", my_model.name)
		output << sprintf("%-20s %s\n", "MEDIA TYPE:", my_model.class.to_s)
		output << sprintf("%-20s %s\n", "DATE ADDED:", my_model.timestamp)
		output << sprintf("%-20s %s\n", "FILE EXTENSION:", my_model.extension)
		output << sprintf("%-20s %s\n", "KEYWORDS:", keywords)
		output
	end


	def keywords
		if my_model.keywords.empty?
			"There are no keywords."
		else
			my_model.keywords.join(', ')
		end
	end


	private

	def menu_options
		{
			:execute => "View photo",
			:tag => "Add a keyword",
			:untag => "Delete an existing keyword",
		}.merge(super)
	end


	def make_controller
		MediaController.new(self)
	end


	def cmd_tag
		keyword = ask "Enter a keyword:"
		my_controller.add_keyword(keyword)
	end


	def cmd_untag
		keyword = ask "Which keyword do you want to delete?"
		my_controller.delete_keyword(keyword)
	end


	def cmd_execute
		my_controller.execute
	end
end


class SearchResultView < View
	include ContainableView

	def body
		content_tabular_display("No search results found.")
	end


	private
	def make_controller
		SearchResultController.new(self)
	end


	def menu_options
		{
			:open => "Open an album or a photo",
		}.merge(super)
	end
end