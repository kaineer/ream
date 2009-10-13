#
#
#

require 'cubetext/role'

class CubeText
  #
  #
  #
  class AnchorRole < Role
    #
    #
    include UsesExtra
    
    #
    #
    def initialize
      super( 'a' )
    end
    
    #
    #
    def extra_attr( extra )
      result = ""
      if /^([^\[\]\{\}]+)/ === extra
        result << " href=\"#{$~[1]}\""
      end
      
      if /\{(.*)\}/ === extra
        result << " id=\"#{$~[1]}\""
      end
      
      result
    end
  end
  
  #
  #
  class EmptyHtmlRole < Role
    #
    #
    include Empty
  end
  
  #
  #
  #
  class ImageRole < Role
    
    include UsesExtra
    include Empty
    
    #
    #
    def initialize
      super( 'img' )
    end
    
    #
    #
    def extra_attr( extra )
      result = ""
      if /^(\S+)/ === extra
        result << " src=\"#{$~[1]}\""
      end
      if /\"(.*)\"/ === extra # "
        result << " alt=\"#{$~[1]}\""
      else
        result << " alt=\"\""
      end
      if /\((\d+)x(\d+)(\*(\d+))?\)/ === extra
        result << " width=\"#{$~[1]}\""
        result << " height=\"#{$~[2]}\""
        result << " border=\"#{$~[4]}\"" unless $~[3].nil?
      end
      
      result
    end
  end
  
  #
  #
  class EntityRole < Role
    
    include Empty
    
    #
    #
    def entity?
      true
    end
  end
  
  def config_html
    url = AnchorRole.new
    @roles[ 'a' ]   = url
    @roles[ 'url' ] = url
    
    img = ImageRole.new
    @roles[ 'img' ] = img
    @roles[ 'image' ] = img
    
    @roles[ 'br' ] = EmptyHtmlRole.new( 'br' )
    @roles[ 'hr' ] = EmptyHtmlRole.new( 'hr' )
  end
end

