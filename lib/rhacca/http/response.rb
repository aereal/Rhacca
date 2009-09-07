# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

module Rhacca
	module HTTP
		class Response
			attr_reader :body
			attr_accessor :media_type, :charset
			
			def initialize
				@status = 200
				@body = []
				@media_type = "text/html"
				@charset = "utf-8"
				@header = {}
				
				%w( content_language content_location last_modified ).each do |i|
					self.class.module_eval {
						define_method(i) { @header[i.to_sym] }
						define_method(i + "=") {|val| @header[i.to_sym] = val }
					}
				end
			end
			
			def put
				puts "Status: #{status_line}"
				puts "Content-Type: #{content_type}"
				puts "Content-Length: #{content_length}"
				@header.each do |field, value|
					puts "#{field.to_s.gsub("_", "-")}: #{value}"
				end
				puts
				puts @body.join("\n")
			end
			
			def status
				@status
			end
			
			def status=(val)
				@status = val.to_i
			end
			
			def reason
				STATUS_CODE[@status]
			end
			
			def status_line
				"#{@status} #{reason}"
			end
			
			def informed?
				(@status >= 100) && (@status < 200)
			end
			
			def succeeded?
				(@status >= 200) && (@status < 300)
			end
			
			def redirected?
				(@status >= 300) && (@status < 400)
			end
			
			def client_errored?
				(@status >= 400) && (@status < 500)
			end
			
			def server_errored?
				@status >= 500
			end
			
			def failed?
				client_errored? || server_errored?
			end
			
			def content_length
				@body.join("\n").size
			end
			
			def content_type
				"#{@media_type}; charset=#{@charset}"
			end
			
			def last_modified
				# TODO: implement
				Time.now.httpdate
			end
			
			def [](key)
				@header[key]
			end
			
			def []=(key, val)
				@header[key] = val
			end
		end
	end
end
