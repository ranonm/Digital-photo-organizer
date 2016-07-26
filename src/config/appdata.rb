=begin
  * Name: PIXBox photo organizer 
  * Author: Ranon Martin - rm1905@nova.edu
  * Date: December 2014
=end
module AppData
	extend self

	def parameter(*names)
  	names.each do |name|
  		attr_accessor name

  		define_method name do |*values|
    		value = values.first
    		value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
  		end
  	end
	end


	def config(&block)
  	instance_eval(&block)
	end


	AppData.config do
		parameter :data_storage, :file_storage
    parameter :file_extensions
	end
end
