=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
module Breadcrumb
	def Breadcrumb.output
		@breadcrumb ||= []
		ending_arrow = @breadcrumb.empty? ? "" : " > "
		@breadcrumb.join(' > ') << ending_arrow
	end


	def Breadcrumb.add(view)
		@breadcrumb << view.my_model.name
	end


	def Breadcrumb.pop
		@breadcrumb.pop
	end


	def Breadcrumb.clear
		@breadcrumb.clear
	end
end