#
#
#

class CubeText
  #
  #
  class Role
    #
    # [+element_name+]
    # [+options+]
    # [+attrubutes+] 
    #
    def initialize( element_name )
      @element_name = element_name
      @options = nil
      @attributes = {}
    end
    
    
    #
    #
    def has_close_tag?
      @options.nil? or !@options.include?( :empty )
    end
    
    def uses_extra?;   false; end
    def entity?;       false; end
    def owner_syntax?; false; end
    
    attr_reader :element_name
    attr_reader :attributes
    attr_accessor :options

  protected
    #
    def attr_value0( value, render_options )
      @xml = render_options.include?( :xml )
      @unquote = render_options.include?( :unquote )

      raise "Can not handle xml and unquote modes together" if @xml && @unquote

      if @unquote && /^(\d+|[a-zA-Z]+)$/ === value
        value
      else
        "\"#{value}\""
      end
    end
  end

  #
  #
  #
  module UsesExtra
    def uses_extra?; true; end
  end
  
  #
  #
  #
  module Empty
    def has_close_tag?; false; end
  end

  #
  #
  #
  module OwnerSyntax
    def owner_syntax?; true; end

    #
    def start_tag( extra )
      raise "#{self.class.name}#start_tag not defined!"
    end

    #
    def end_tag( extra )
      raise "#{self.class.name}#end_tag not defined!"
    end
  end


  @@plugins = {}

  #
  #
  def config_plugins
    @roles.merge!( @@plugins )
  end
end
