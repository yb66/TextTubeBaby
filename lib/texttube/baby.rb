module TextTube
	# The original. Maybe. I haven't checked.
  module Baby

		# Require all the filters.
		# The `map` is there to show the result of this and
		# show which libs were required (if so desired).
		# @return [Array<String,TrueClass>]
		def self.load_all_filters filters=nil
			filters ||= File.join __dir__, "baby/*.rb"
			warn "filters = #{filters}"
			Dir.glob( filters )
				 .reject{|name| name.end_with? "version.rb" }
				 .map{|filter| 
					 tf = require filter
					 [File.basename(filter, ".rb").gsub("_",""), tf]
				 }
		end

  end
end
