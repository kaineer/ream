require 'test/unit'
require 'yaml'
require 'mocha'

World( Test::Unit::Assertions )

# preferring to test what in lib dir
$:.unshift( "../../lib" )

# CubeText
require 'cubetext'

class String
  def escape
    self.gsub( "\\n" ){||$/}.gsub( "\\\"" ){||"\""}
  end
end
