#
#
#
#
#

require 'ream/template'
require 'ream/blog/overrides/template'

require 'ream/sources/fs'

require 'ream/blog/template_processor'
require 'ream/blog/template_processor/defaults'

require 'ream/blog/configuration'

module Ream
  module Blog
    class Sources
      def initialize( source_file = Ream::Blog::Configuration.sources )
        @source_hashes = Ream::Template.scan( source_file ).
          with( Ream::Blog::TemplateProcessor )
        @sources = {}
      end

      def []( key )
        @sources[ key.to_s ] ||= 
          source_from_hash( @source_hashes[ key.to_s ] )
      end

    protected
      def source_from_hash( hash )
        Ream::Sources::FS.new( hash[ "root" ], hash[ "mask" ] )
      end
    end


    class SourceHash
      def initialize( hash )
        @root = hash[ "root" ]
        @mask = hash[ "mask" ]
      end

      attr_reader :root, :mask

      def wildcard
        File.join( root, mask )
      end
    end
  end
end
