require 'test/unit'
require 'yaml'

require 'mocha'

World( Test::Unit::Assertions, Mocha::API )

Before do
  mocha_setup
end
 
After do
  begin
    mocha_verify
  ensure
    mocha_teardown
  end
end

# preferring to test what in lib dir
$:.unshift( "../../lib" )

# CubeText
require 'cubetext'

class String
  def escape
    self.gsub( "\\n" ){||$/}.gsub( "\\\"" ){||"\""}
  end
end
