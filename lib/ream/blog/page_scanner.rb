#
#
#
#
#

module Ream
  #
  module Blog
    #
    class PageScanner
      #
      #
      #
      INDEX_SRC = "index.src"
      DIR_INDEX_SRC = "*/#{INDEX_SRC}"
      SAME_DIR_SRC = "*.src"
      
      #
      #
      def initialize( config )
        @config = config
        @pages  = Hash.new
        @root   = nil
      end
      
      #
      attr_reader :root, :pages
      
      #
      def scan_pages
        Dir.chdir( @config.pages_root ) { scan_pages0( nil, "." ) }
      end
      
    protected
      #
      def scan_pages0( index, directory )
        index ||= scan_root( directory )
        index.index!
        scan_samedir( directory, index )
        scan_subdir_indexes( directory, index )
      end
      
      #
      def scan_root( directory )
        @root = Page.new( 
          File.join( directory, INDEX_SRC )
        )
        
        register_page( @root )
      end
      
      #
      def scan_samedir( directory, index )
        get_samedir_pages( directory ).each do |page_src|
          register_page( Page.new( page_src, index ) )
        end
      end
      
      #
      def scan_subdir_indexes( directory, index )
        get_subdir_pages( directory ).each do |page_src|
          page = Page.new( page_src, index )
          register_page( page )
          scan_pages0( page, File.dirname( page_src ) )
        end
      end
      
      #
      def register_page( page )
        raise "Some paths are the same: #{page.path}" if @pages.has_key?( page.path )
        @pages[ page.path ] = page
      end
      
      #
      def get_samedir_pages( directory )
        Dir[ File.join( directory, SAME_DIR_SRC ) ] -
        Dir[ File.join( directory, INDEX_SRC ) ]
      end
      
      #
      def get_subdir_pages( directory )
        Dir[ File.join( directory, DIR_INDEX_SRC ) ]
      end
    end
  end
end
