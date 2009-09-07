#!/usr/bin/env ruby
#
# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

$:.unshift "/virtual/aereal/lib/ruby/site_ruby/1.8"

require "rhacca"

class Yuno < Rhacca::Application
	@@error_handler = :handler
	
	def initialize
		@config = {}
	end
	
	def index(*)
		response.body << "X / _ / X < Hello World"
	end
	route "/", :index
	
	def say(message)
		response.body << "X / _ / X < #{message}"
	end
	route "/say/:message", :say
	
	route "/bye", :bye, do
		response.body << "X ; _ ; X < Bye"
	end
	
	private
	def handler(e)
		res = Rhacca::HTTP::Response.new
		res.media_type = "text/plain"
		res.status = 500
		res.body << e.message << e.backtrace.join("\n")
		res.put
	end
end

Yuno.run