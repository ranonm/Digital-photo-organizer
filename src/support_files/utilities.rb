=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
module Utilities
	def ask(question)
		print question << " "
		gets.chomp
	end


	def confirm(short_msg)
		message = "CONFIRMATION REQUEST: " 
		message <<  short_msg 
		message << "(yes or no)"

		choice = ask(message).downcase

		case choice
		when "yes"
			return true
		when "no"
			return false
		else
			system_msg("That's an unknown option -- assuming you meant 'no'")
			return false
		end
	end


	def system_msg(message, type = :default, time = 2)
		puts format_message(message, type)
		sleep(time)
	end


	def format_message(message, type)
		case type
		when :error
			return message.prepend("ERROR: ").red
		when :success
			return message.prepend("SUCCESS: ").green
		else
			return message.prepend("INFO: ").blue
		end
	end
end