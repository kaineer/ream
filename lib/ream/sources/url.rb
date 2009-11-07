# * hash - hash in format { "url1" => "http://domain.com/foo/bar", ... }
#
#

require 'net/http'

module Ream
  module Sources
    class Url
      def initialize( hash )
        @hash = hash
      end

      def each( &block )
        @hash.each do |key, url|
          value = get_url_data( url )
          block.call( key, value )
        end
      end

      def get_url_data( url )
        # TODO: get by http
      end
    end
  end
end
