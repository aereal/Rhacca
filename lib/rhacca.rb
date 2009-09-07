# Copyright (c) 2009-09-03 Aoki Hanae
# <http://aereal.org/>
#
# License: <http://opensource.org/licenses/zlib-license.php>
#

require "core_ext"

module Rhacca
	VERSION = "0.0.1"
	
	dir = File.dirname(__FILE__) / "rhacca"
	autoload :Application, dir / "app.rb"
	autoload :Error, dir / "error.rb"
	autoload :HTTP, dir / "http.rb"
	autoload :Util, dir / "util.rb"
end
