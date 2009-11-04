module Ream
  module Blog
    #
    #
    class RenderParameters < Parameters
      #
      #
      def initialize
        @page = nil
        @config = nil
        @cache = {}
      end

      attr_reader :page, :config
      attr_accessor :navigation

      #
      #
      def page=( _page )
        @page = _page
        @cache.clear
      end

      #
      #
      def config=( _config )
        @config = _config
        @cache.clear
      end

      #
      #
      def []( key )
        return @cache[ key ] if @cache.has_key?( key )
        @cache[ key ] = call_by_string( key )
      end
    end
  end
end
