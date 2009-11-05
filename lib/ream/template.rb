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

require 'ream/template/re'
require 'ream/template/hash_builder'

#
module Ream
  #
  module Template
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
        @items = HashBuilder.new

        IO.read( path ).each_line do |line|
          @line = line.chomp
          scan_line
        end

        @items.to_hash
      end
      
      #
      #
      def scan_line
        if title?    then @items.open( @title )
        elsif close? then @items.close!
        elsif comment? # skip line
        else              @items << strip_start
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
