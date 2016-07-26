=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
class String
	def decorate(code)
		"\e[#{code}m#{self}\e[0m"
	end


	def red
		decorate(31)
	end


	def green
		decorate(32)
	end


	def yellow
		decorate(33)
	end


	def blue
		decorate(34)
	end


	def bold
		decorate(1)
	end


	def underline
		decorate(4)
	end


	def faint
		decorate(2)
	end
end