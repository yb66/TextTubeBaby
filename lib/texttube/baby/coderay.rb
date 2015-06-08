# encoding: UTF-8
module TextTube

  require 'oga'
  require_relative "../../ext/blank.rb"
  require 'coderay'
  require "texttube/filterable"

	module Baby

		# a filter for Coderay
		# @note Thanks to Rob Emerson for sharing his nanoc filter which helped me write this.
		# @see http://www.remerson.plus.com/articles/nanoc-coderay/
		module Coderay
			extend Filterable

			filter_with :coderay do |text|
				run text
			end


			# @param [String] content
			# @param [Hash] options
			# @return [String]
			def self.run(content, options={})
				options = {lang: :ruby } if options.blank?
				doc = Oga.parse_html content

				if (xpath = doc.xpath("pre/code"))
				  xpath.map do |codeblock|
            #un-escape as Coderay will escape it again
            inner_html = codeblock.inner_text

            # following the convention of Rack::Codehighlighter
            if inner_html.start_with?("::::")
              lines = inner_html.split("\n")
              options[:lang] = lines.shift.match(%r{::::(\w+)})[1].to_sym
              inner_html = lines.join("\n")
            end

            if (options[:lang] == :skip) || (! options.has_key? :lang )
              codeblock.inner_text = inner_html
            else
            # html_unescape(inner_html)
            #  code = codify(html_unescape(inner_html), options[:lang])
              code = Coderay.codify(Coderay.html_unescape(inner_html), options[:lang])
              # It needs to be parsed back into Oga
              # or the escaping goes wrong
              codeblock.children= Oga.parse_html( code ).children
              codeblock.set "class", "CodeRay"
            end
          end#block
          doc.to_xml
        else
          content
        end
			end#def

			# @private
			# Unescape the HTML as the Coderay scanner won't work otherwise.
			def self.html_unescape(a_string)
				a_string.gsub('&amp;', '&').gsub('&lt;', '<').gsub('&gt;', 
				'>').gsub('&quot;', '"')
			end#def

			# Run the Coderay scanner.
			# @private
			# @param [String] str
			# @param [String] lang
			# @example
			#   self.class.codify "x = 2", "ruby"
			def self.codify(str, lang)
				::CodeRay.scan(str, lang).html
			end#def

		end#class
 end
end#module