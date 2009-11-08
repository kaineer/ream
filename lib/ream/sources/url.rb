#==============================================================
# module: Ream::Sources::Url
#   date: 2009.11.08
#
#  brief: Loading sources data from urls
#==============================================================

require 'open-uri'

module Ream
  module Sources
    class Url
      # hash in format "key" => "http://some.url"
      #
      def initialize( hash )
        @hash = hash
        @cache = {}
      end

      def each( &block )
        @hash.each do |key, url|
          value = ( @cache[ key ] ||= open( url ).read )
          block.call( key.to_s, value )
        end
      end
    end
  end
end
