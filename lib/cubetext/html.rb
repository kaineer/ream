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
    def extra_attr( extra, render_options )
      result = ""
      if /^([^\[\]\{\}]+)/ === extra
        result << " href=#{attr_value0( $~[1], render_options )}"
      end
      
      if /\{(.*)\}/ === extra
        result << " id=#{attr_value0( $~[1], render_options )}"
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
    def extra_attr( extra, render_options )
      result = ""
      if /^(\S+)/ === extra
        result << " src=#{attr_value0( $~[1], render_options )}"
      end
      if /\"(.*)\"/ === extra # "
        result << " alt=#{attr_value0( $~[1], render_options )}"
      else
        result << " alt=\"\""
      end
      if /\((\d+)x(\d+)(\*(\d+))?\)/ === extra
        result << " width=#{attr_value0( $~[1], render_options )}"
        result << " height=#{attr_value0( $~[2], render_options )}"
        result << " border=#{attr_value0( $~[4], render_options )}" unless $~[3].nil?
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
