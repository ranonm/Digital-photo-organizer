=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
class ViewStack
	class << self
		def add(view)
			@stack ||= []
			@stack << view
		end


		def previous
			return nil if @stack.nil?
			@stack.pop
		end


		def last
			return nil if @stack.nil?
			view = @stack.first
			@stack.clear
			view
		end
	end
	
	private_class_method :new
end