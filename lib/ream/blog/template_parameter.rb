#
#
#

require 'ream/blog/configuration'

module Ream
  module Blog
    module TemplateParameter
      def self.load( path = Ream::Blog::Configuration.parameters, &callback )
        Dir[ path ].each do |filename| 
          callback.call( filename ) if block_given?
          require filename
        end
      end

      def self.[]( key )
        klazz = has_key?( key )
        klazz ? klazz.new( key ).value : nil
      end

      def self.has_key?( key )
        @@parameters.find{|klazz|
          klazz.matches?( key )
        }
      end

      @@parameters ||= []
    end
  end
end
