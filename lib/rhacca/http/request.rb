# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

require "pathname"

module Rhacca
	module HTTP
		class Request
			def initialize
				@env = ENV.inject({}) {|ret, item|
					key, val = *item
					ret[key.gsub(/^HTTP_/, "").downcase] = val
					ret
				}
				
				self.class.module_eval do
					%(
					auth_type gateway_interface path_translated
					remote_host remote_ident remote_user remote_addr
					server_name server_protocol
					cache_control from negotiate pragma referer user_agent
					).each do |env|
						define_method(env) { @env[env] }
					end
					
					%(accept accept_charset accept_encoding accept_language).each do |acp|
						define_method(acp) { parse_accept @env[acp] }
					end
				end
			end
			
			def if_modified_since
				if since = @env["if_modified_since"]
					Time.httpdate since
				end
			end
			
			def if_none_match
				@env["if_none_match"]
			end
			
			def not_modified?(modified_at)
				if_modified_since && modified_at && if_modified_since >= modified_at
			end
			
			def etag_matched?(etag)
				if_none_match && if_none_match == etag
			end
			
			def path_info
				Pathname.new(@env["path_info"] || "/")
			end
		end
	end
end
