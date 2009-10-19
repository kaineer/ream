require 'test/unit'
require 'yaml'

World( Test::Unit::Assertions )


# CubeText

require 'cubetext'

class String
  def escape
    self.gsub( "\\n" ){||$/}
  end
end
