# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

module Rhacca
	module Util
		module_function
		def render(rendering_engine, temp_file, vars={})
			case rendering_engine
			when :erb
				require "erb"
				
				obj = Object.new
				obj.class.instance_eval do
					vars.each do |k, v|
						define_method(k) { v }
					end
				end unless vars.empty?
				obj.instance_eval do
					ERB.new(File.read(config["template_path"] / temp_file)).result(binding)
				end
			end
		end
	end
end
