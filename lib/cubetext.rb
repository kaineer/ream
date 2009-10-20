# ---
# Options' switches supported:
# `|' - verbatime content
# `<' - skip first empty line (for verbatime content)
# '>' - skip last empty line (for verbatime content)
# '*' - empty tag
# ---
# YAML config:
# <role-name>:
#   [elt: <html-element name>] # for basic element
#   [attr:                     # attributes, if present
#     <html-attr name>: <html-attr value>]
#   [opt: <option-switches>]   # options for basic element
#   [ent: <entity-name>]       # for some special characters
#   [class: <class-name>]      # can be used, but not necessary.
# ---
#

require 'cubetext/html' # html roles

class Hash
  def first_value( obj )
    case obj
    when Array
      key = obj.find{ |k| !self[k].nil? }
      self[ key ] unless key.nil?
    else self[ obj ]
    end
  end
end

class CubeText
  #
  #
  #
  class Fragment
    #
    #
    def initialize( obj )
      unless obj.nil?
        @role_name, @options = parse_name( obj )
      end
      @child = []
    end

    #
    #
    def root?
      @role_name.nil?
    end

    #
    #
    def <<( obj )
      case obj
      when Fragment then @child << obj
      when String then append_string( obj )
      end
    end

    attr_reader :role_name
    attr_reader :child
    attr_reader :options
    attr_reader :extra

    protected
    #
    #
    def parse_name( obj )
      case obj
      when String then name = obj
      when Array  then name, @extra = obj
      end

      case name
      when /^(\w+)(.*)$/ then [
                               $~[1], CubeText::parse_options( $~[2] ) ]
      else raise "Unknown fragment role: `#{name}'"
      end
    end

    #
    #
    def append_string( str )
      ( @child.last.is_a?( String ) ? @child.last : @child ) << str
    end
  end

  #
  #
  #
  class RootFragment < Fragment
    #
    #
    def initialize
      super( nil )
    end
  end

  #
  #
  def initialize
    @roles = {}
    @fragment = nil
    @xml = false
    @unquote = false
  end

  # Set xml and unquote flags
  #
  def xml!; @xml = true; end
  def unquote!; @unquote = true; end

  #
  #
  def parse( text )
    text_tail = text.
      gsub( /\s*\[(\/|skip)\]\s*\n\s*/ ) {''}
    @fragment = RootFragment.new # Fragment.new( nil )
    current_fragment = @fragment
    stack = []

    until text_tail.empty?
      event, lexem, text_tail = get_lexem( text_tail )

      case event
      when LEXEM_FRAGMENT_BEGIN
        new_fragment = Fragment.new( lexem ) # SMELL: duplication
        current_fragment << new_fragment     #

        stack << current_fragment
        current_fragment = new_fragment

      when LEXEM_FRAGMENT_EMPTY
        new_fragment = Fragment.new( lexem ) #
        current_fragment << new_fragment     #

      when LEXEM_FRAGMENT_END
        current_fragment = stack.pop

      when LEXEM_TEXT
        current_fragment << lexem
      end
    end
  end

  #
  #
  def config_roles( roles )
    config_plugins()
    config_html()

    return unless roles.is_a?( Hash )

    roles.each do |role_name, cfg_hash|
      unless (klass = cfg_hash[ 'class' ]).nil?
        begin
          role = reuse_role_if_possible( role_name ) {
            eval( klass ).new
          }
        rescue
        end
      end

      unless (ent = cfg_hash.first_value( %w( ent entity ) ) ).nil?
        role = reuse_role_if_possible( role_name ) {
          EntityRole.new( ent )
        }
      end

      unless (elt = cfg_hash.first_value( %w( element elt ) )).nil?
        role = reuse_role_if_possible( role_name ) { Role.new( elt ) }

        attr = cfg_hash.first_value( %w( attribute attr ) )
        unless attr.nil?
          attr.each do |k, v|
            role.attributes[ k ] = v
          end
        end

        opt = cfg_hash.first_value( %w( options opt ) )
        unless opt.nil?
          role.options ||= CubeText::parse_options( opt )
        end
      end
    end # each |role_name, cfg_hash|
  end

  #
  #
  def to_html
    to_html0( @fragment )
  end

  OPTIONS = {
    '<' => :skip_first_empty_line,
    '>' => :skip_last_empty_line,
    '|' => :verbatime,
    '*' => :empty,
    '-' => :punctuation # not used, though
  }

  # Lexem kinds
  #
  #
  LEXEM_TEXT           = 0
  LEXEM_FRAGMENT_BEGIN = 1
  LEXEM_FRAGMENT_END   = 2
  LEXEM_FRAGMENT_EMPTY = 3

  #
  #
  def self.parse_options( options )
    OPTIONS.inject( [] ) {|array, pair|
      k, v = *pair
      options.include?( k ) ? array + [ v ] : array
    }
  end

protected
  #
  #
  def get_lexem( text_tail )
    case text_tail
    when /\A\[(\w+[\<\>\|-]*)\[/m then [ LEXEM_FRAGMENT_BEGIN, $~[1], $' ]
    when /\A\[(\w+[\<\>\|-]*)\s+([^\[\]]+)\[/m then [ LEXEM_FRAGMENT_BEGIN, [ $~[1], $~[2] ], $' ]
    when /\A\]\]/m                then [ LEXEM_FRAGMENT_END,   nil,   $' ]
    when /\A\[\[/m                then [ LEXEM_TEXT, '[', $' ]
    when /\A\[\]/m                then [ LEXEM_TEXT, ']', $' ]
    when /\A([^\[\]]+)/m          then [ LEXEM_TEXT, $~[1], $' ]
    when /\A\[(\w+)\]/m           then [ LEXEM_FRAGMENT_EMPTY, $~[1], $' ]
    when /\A\[(\w+)\s+([^\[\]]+)\]/m then [ LEXEM_FRAGMENT_EMPTY, [ $~[1], $~[2] ], $' ]
      # TODO: Some more cases
      #
    else raise "Can't parse: `#{text_tail[0..40]}'"
    end
  end

  # Text options
  # :begin - first child
  # :end   - last child
  #

  #
  #
  def render_options
    @render_options ||= 
      [ ( @xml ? :xml : nil ),
        ( @unquote ? :unquote : nil ) 
      ].compact
  end

  #
  #
  def to_html0( fragment )
    result = ""
    fragment.child.each_with_index do |obj, i|
      case obj
      when String
        options = []
        options << :first if i == 0
        options << :last  if i == (fragment.child.size - 1 )
        options << :verbatime if fragment.role_name.nil?

        options |= fragment.options unless fragment.options.nil?

        role = @roles[ fragment.role_name ]
        unless role.nil?
          options |= role.options unless role.options.nil?
        end

        result  << normalize( obj, options ).gsub(/</){'&lt;'}.gsub(/>/){'&gt;'}
      when Fragment
        result << start_tag( obj )
        result << to_html0( obj )
        result << end_tag( obj )
      end
    end
    result
  end

  #
  # Warning: it changes str onplace!
  def normalize( str, options )
    unless options.include?( :verbatime )
      str.gsub!( /\s+/m ){' '}
      str.gsub!( /\A\s+/m ) {''} if options.include?( :first )
      str.gsub!( /\s+\Z/m ) {''} if options.include?( :last )
    else
      str.gsub!( /\A\s*\n/m ) {''} if options.include?( :skip_first_empty_line )
      str.gsub!( /\n\s*\Z/m ) {''} if options.include?( :skip_last_empty_line )
    end

    str
  end

  #
  #
  def start_tag( fragment )
    role_name = fragment.role_name
    role = @roles[ role_name ]

    case
    when (!role.nil? and role.owner_syntax?)
      role.start_tag( fragment.extra )
    when (!role.nil? and role.entity?)
      "&#{role.element_name};"
    else
      "<" +
        tag_name( fragment ) +
        attr0( fragment ) +
        ( @xml && role && !role.has_close_tag? ? "/" : "" ) +
        ">"
    end
  end

  #
  #
  def end_tag( fragment )
    role_name = fragment.role_name
    role = @roles[ role_name ]
    case
    when (!role.nil? and role.owner_syntax? and role.has_close_tag?)
      role.close_tag( fragment.extra )
    when (role.nil? or role.has_close_tag?)
      "</" +
        tag_name( fragment ) +
        ">"
    end.to_s
  end

  #
  #
  def tag_name( fragment )
    role_name = fragment.role_name
    return role_name if ( role = @roles[ role_name ] ).nil?
    role.element_name
  end

  #
  #
  def attr0( fragment )
    role = @roles[ fragment.role_name ]
    case
    when ( role.nil? or
           role.attributes.nil? ) then ''
    when ( role.uses_extra? and not
           fragment.extra.nil? ) then role.extra_attr( fragment.extra, render_options )
    else
      attr = role.attributes
      attr.keys.sort{|a,b|a<=>b}.collect do |k|
        v = attr[k]
        if k.downcase == "style" && v.is_a?( Array )
          " #{k}=\"#{v.join(';')}\""
        else
          if v
            " #{k}=#{attr_value0(v)}"
          else
            @xml ? " #{k}=\"#{k}\"" : " #{k}"
          end
        end
      end.join('')
    end # case
  end

  #
  #
  def attr_value0( value )
    raise "Can not handle xml and unquote modes together" if @xml && @unquote

    if @unquote && /^(\d+|[a-zA-Z]+)$/ === value
      value
    else
      "\"#{value}\""
    end
  end

  ### Methods, added on refactoring

  # Create new [+Role+] object,
  # or reuse existing
  #
  def reuse_role_if_possible( name, &block )
    unless @roles.has_key?( name )
      @roles[ name ] = block.call()
    end
    @roles[ name ]
  end

  # Get element data from config hash,
  #   and put it into role's object
  #
  def config_element_role( role, hash )
    # Attributes data
    #
    attr = hash.first_value( %w( attribute attr ) )
    unless attr.nil?
      attr.each do |name, value|
        role.attributes[ name ] = value
      end
    end

    # Options data
    #
    #
    opt = hash.first_value( %w( options opt ) )
    role.options ||= CubeText::parse_options( opt ) unless opt.nil?
  end
end
