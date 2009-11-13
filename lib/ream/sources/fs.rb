#==============================================================
# module: Ream::Sources::FS
#   date: 2009.11.08
#
#  brief: Loading sources data from files
#==============================================================

module Ream
  module Sources
    class FS
      #   May be used for getting text from files in filesystem
      #   * root_dir
      #   * masks - several masks to get content from
      #   * block - block to transform filename into key
      def initialize( root_dir = ".", masks = [ "**/*.tpl" ], &block )
        @root_dir = File.expand_path( root_dir )
        @masks    = masks
        @block    = proc( &block ) if block_given?
      end

      def files
        @files ||= Dir.chdir( @root_dir ) do
          @masks.inject( [] ) do |files, mask|
            files + Dir[ mask ]
          end
        end
      end

      def keys
        @keys ||= Dir.chdir( @root_dir ) do
          files.map{|filename| get_key( filename )}
        end
      end
      
      def each( &block )
        Dir.chdir( @root_dir ) do
          @masks.each do |mask|
            Dir[ mask ].each do |filename|
              key = get_key( filename )
              block.call( key, IO.read( filename ) )
            end
          end
        end
      end

      def get_key( filename )
        if @block
          @block.call( filename )
        else
          filename[ /^(.*)\.\w+$/, 1 ]
        end
      end
    end
  end
end
