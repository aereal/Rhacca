# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

module Rhacca
	class Application
		include Rhacca::Util
		
		attr_reader :config
		
		@@action_map = []
		@@filters = []
		@@error_handler = :default_error_handler
		
		class << self
			def run
				app = new
				params = []
				action = @@action_map.find {|i|
					m = i[:pattern].match(app.request.path_info)
					params.concat m.captures if m
				}
				
				raise Rhacca::HTTP::NotFound unless action
				
				@@filters.each do |filter|
					app.__send__ filter
				end
				
				app.__send__ action[:action], *params
			rescue => e
				app.__send__ @@error_handler, e
			else
				app.response.put
			end
			
			private
			def route(path, action, vars={}, &block)
				path = path == "/" ? ["", ""] : path.split("/")
				has_params = path.any? {|f| f.start_with? ":" }
				
				raise ArgumentError if has_params && vars.empty?
				
				path = path.map {|i|
					i.start_with?(":") ? "(#{vars[i[1..-1].to_sym]})" : i
				} if has_params
				
				define_method(action, &block) if block_given?
				
				@@action_map.push :pattern => Regexp.compile(path.join("/") + "$"), :action => action.to_sym
			end
			
			def filter(*actions)
				@@filters.concat actions
			end
		end
		
		def initialize
			@config = YAML.load_file("./config.yaml")
		end
		
		def request
			@request ||= Rhacca::HTTP::Request.new
		end
		
		def response
			@response ||= Rhacca::HTTP::Response.new
		end
		
		private
		def default_error_handler(error)
			# ...
		end
	end
end
