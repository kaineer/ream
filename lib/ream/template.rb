#===============================================================
#  class: Ream::Template
#   date: 2005.11.18
#   date: 2008.11.12 - some changes to make more it readable
#
#  brief: Reading templates from textfile/current
#   note: reincarnation, yeah..
#===============================================================
 
=begin
--- use.cases
### Use cases ###
 
# --- Placing in comments text to be used in output, then use it
require 'ream/template'
 
tpl = Ream::Template.scan() # scan templates from source itself
tpl = Ream::Template.scan( __FILE__, filename ) # from itself and outer source
 
tpl[ 'tpl.name' ] => template text
tpl[ 'tpl.name', { 'param' => 'value' } ]       # template text where %param%
                      # replaced with value
---
=end

#
module Ream
  #
  module Template

    #
    module RE
      #
      def self.expand_includes; /\{([\w.:]+)\}/; end
      def self.expand_params; /%([\w.:]+)%/; end
    end

    #
    #
    #
    class Expand
      #
      #
      def initialize( items )
        @items = items
      end
      
      #
      #
      def []( name, params = {} )
        expand( name, params )
      end
      
      #
      #
      def has_template?( name )
        @items.has_key?( name )
      end
      
    protected
      #
      def expand( name, params )
        return unknown_template( name ) unless has_template?( name )
        expand_params( expand_includes( @items[ name ], params ), params )
      end
    
      #
      def expand_includes( text, params )
        text.gsub( RE.expand_includes ) { || expand( $~[1], params ) }
      end
 
      #
      def expand_params( text, params )
        text.gsub( RE.expand_params ) { |f| params.has_key?( $~[1] ) ? params[ $~[1] ] : f }
      end
      
      #
      def unknown_template( name )
        "\{#{name}\}"
      end
    end

    # 
    #
    #
    class Scanner
      #
      #
      def scan( path )
        @items = Items.new
        IO.read( path ).each_line do |line|
          @line = line.chomp
          scan_line
        end
        @items.items
      end
      
      #
      #
      def scan_line
        if title?    then @items.add_item( @title )
        elsif close? then @items.close_item
        elsif comment? # skip line
        else              @items.add_line( strip_start )
        end
      end
      
    protected
      #
      def title?; @title = @line[ /^---\s*([\w.:]+)/, 1 ]; end
      
      #
      def close?; /^---/ === @line; end
      
      #
      def comment?; /^\s*#/ === @line; end
      
      #
      def strip_start; @line.sub( /^~/, '' ); end
    end

    #
    #
    #
    class Items
      #
      def initialize
        @items = {}
        @last_item = nil
      end
      
      attr_reader :items
      
      #
      def add_item( name )
        @last_item = String.new
        @items[ name ] = @last_item
      end
      
      #
      def close_item
        @last_item = nil
      end
      
      #
      def add_line( line )
        return unless @last_item
        @last_item << $/ unless @last_item.empty?
        @last_item << line
      end
    end
    
    #
    #
    def self.scan( *args )
      scanner = Scanner.new
      
      paths = args.empty? ? 
        [ File.expand_path( caller[ 0 ][ /^(([a-z]:)?([^:]+)):/i, 1 ] ) ] : args

      items = {}
      paths.each do |path|
        items.merge!( scanner.scan( path ) )
      end
      expand( items )
    end

    #
    #
    def self.expand( items )
      Expand.new( items )
    end
  end
end



