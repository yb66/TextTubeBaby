# encoding: UTF-8
require 'nokogiri'
require "texttube/filterable"

module TextTube
  module Baby

		# This finds html tags with "markdown='1'" as an attribute, runs markdown over the contents, then removes the markdown attribute, allowing markdown within html blocks
		module InsideBlock
			extend TextTube::Filterable
	
			filter_with :insideblock do |text|
				run text
			end
		
			# @param [String] content
			# @param [Hash] options
			# @option options [Constant] The markdown parser to use. I'm not sure this bit really works for other parsers than RDiscount.    
			def self.run( content, options={})   
				options ||= {} 
				if options[:markdown_parser].nil?
					require 'rdiscount' 
					markdown_parser=RDiscount
				end
				doc = Nokogiri::HTML::fragment(content) 
			
				doc.xpath("*[@markdown='1']").each do |ele|  
					ele.inner_html = markdown_parser.new(ele.inner_html).to_html
					ele.remove_attribute("markdown")
				end
			
				doc.to_s
			end # run
		
		end
  end
end # module
