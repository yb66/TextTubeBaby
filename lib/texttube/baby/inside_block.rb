# encoding: UTF-8
require "texttube/filterable"
require 'oga'

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
				doc = Oga.parse_html(content)
			
				doc.xpath("*[@markdown='1']").each do |ele|
				  inner_text = ele.children.inject(""){|mem,child| mem << child.to_xml }
					html_fragment = markdown_parser.new(inner_text).to_html
					ele.children= Oga.parse_html( html_fragment ).children
					ele.unset "markdown"
				end
			
				doc.to_xml
			end # run
		
		end
  end
end # module
