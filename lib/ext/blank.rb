# encoding: UTF-8

module TextTube
  module CoreExtensions
  
    def blank?
      respond_to?(:empty?) ? 
        empty? :
        !self
    end
  end

	class String < ::String
		include CoreExtensions
	end
end

# Standard lib class.
class Hash
  include TextTube::CoreExtensions
end