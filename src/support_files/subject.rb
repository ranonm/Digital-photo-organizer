=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
module Subject
	def init_subject
		@observers = []
	end


	def add_observer(observer)
		@observers << observer
	end


	def remove_observer(observer)
		@observers.delete(observer)
	end


	def notify_observers
		@observers.each do |observer|
			observer.update(self)
		end
	end
end