# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

module Rhacca
	module HTTP
		dir = File.dirname(__FILE__) / "http"
		autoload :Response, dir / "response.rb"
		autoload :Request, dir / "request.rb"
		
		STATUS_CODE = {
			100 => "Continue",
			101 => "Switching Protocols",
			102 => "Processing",
			200 => "OK",
			201 => "Created",
			202 => "Accepted",
			203 => "Non-Authoritative Information",
			204 => "No Content",
			205 => "Reset Content",
			206 => "Partial Content",
			207 => "Multi-Status",
			226 => "IM Used",
			300 => "Multiple Choices",
			301 => "Moved Permanently",
			302 => "Found",
			303 => "See Other",
			304 => "Not Modified",
			305 => "Use Proxy",
			307 => "Temporary Redirect",
			400 => "Bad Request",
			401 => "Unauthorized",
			402 => "Payment Required",
			403 => "Forbidden",
			404 => "Not Found",
			405 => "Method Not Allowed",
			406 => "Not Acceptable",
			407 => "Proxy Authentication Required",
			408 => "Request Timeout",
			409 => "Conflict",
			410 => "Gone",
			411 => "Length Required",
			412 => "Precondition Failed",
			413 => "Request Entity Too Large",
			414 => "Request-URI Too Long",
			415 => "Unsupported Media Type",
			416 => "Requested Range Not Satisfiable",
			417 => "Exceptation Failed",
			422 => "Unprocessable Entity",
			423 => "Locked",
			424 => "Failed Dependency",
			426 => "Upgrade Required",
			500 => "Internal Server Error",
			501 => "Not Implemented",
			502 => "Bad Gateway",
			503 => "Service Unavailable",
			504 => "Gateway Timeout",
			505 => "HTTP Version Not Supported",
			506 => "Variant Also Negotiates",
			507 => "Insufficient Storage",
			510 => "Not Extended",
		}
		
		class Error < Rhacca::Error; end
		
		# Client-side errors
		class ClientSideError < HTTP::Error; end
		class BadRequest < HTTP::ClientSideError; end
		class Unauthorized < HTTP::ClientSideError; end
		class PaymentRequired < HTTP::ClientSideError; end
		class Forbidden < HTTP::ClientSideError; end
		class NotFound < HTTP::ClientSideError; end
		class MethodNotAllowed < HTTP::ClientSideError; end
		class NotAcceptable < HTTP::ClientSideError; end
		class ProxyAuthenticationRequired < HTTP::ClientSideError; end
		class RequestTimeout < HTTP::ClientSideError; end
		class Conflict < HTTP::ClientSideError; end
		class Gone < HTTP::ClientSideError; end
		class LengthRequired < HTTP::ClientSideError; end
		class PreconditionFailed < HTTP::ClientSideError; end
		class RequestEntityTooLarge < HTTP::ClientSideError; end
		class RequestURITooLong < HTTP::ClientSideError; end
		class UnsupportedMediaType < HTTP::ClientSideError; end
		class RequestedRangeNotSatisfiable < HTTP::ClientSideError; end
		class ExceptationFailed < HTTP::ClientSideError; end
		class UnprocessableEntity < HTTP::ClientSideError; end
		class Locked < HTTP::ClientSideError; end
		class FailedDependency < HTTP::ClientSideError; end
		class UpgradeRequired < HTTP::ClientSideError; end
		
		# Server-side errors
		class ServerSideError < HTTP::Error; end
		class InternalServerError < HTTP::ServerSideError; end
		class NotImplemented < HTTP::ServerSideError; end
		class BadGateway < HTTP::ServerSideError; end
		class ServiceUnavailable < HTTP::ServerSideError; end
		class GatewayTimeout < HTTP::ServerSideError; end
		class HTTPVersionNotSupported < HTTP::ServerSideError; end
		class VariantAlsoNegotiates < HTTP::ServerSideError; end
		class InsufficientStorage < HTTP::ServerSideError; end
		class NotExtended < HTTP::ServerSideError; end
		
		module_function
		def parse_accept(accept_field)
			accept_field.split(/\s*,\s*/).inject([]) {|ret, val|
				media_type, qs = val.split(/\s*;q=/)
				ret << [media_type, qs ? qs.to_f : 1.to_f]
			}.sort_by {|i|
				(i[1] * 1000) - i[0].count("*") + i[0].count(";") + i[0].count("+")
			}.reverse
		end
	end
end
