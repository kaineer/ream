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
require 'ream/template/replacer'
require 'ream/template/scanner'

#
module Ream
  #
  module Template
    #
    #
    def self.scan( *args )
      scanner = Scanner.new
      
      paths = args.empty? ? 
        [ File.expand_path( caller[ 0 ][ /^(([a-z]:)?([^:]+)):/i, 1 ] ) ] : args

      items = {}
      paths.each do |path|
        items.merge!( scanner.scan( IO.read( path ) ) )
      end
      expand( items )
    end

    #
    #
    def self.expand( items )
      Replacer.new( items )
    end
  end
end
