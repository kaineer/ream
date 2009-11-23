#

require 'ream/blog/template_processor'

module Ream
  module Blog
    #
    #
    DEFAULT_TEMPLATE_PROCESSORS = %w( yaml )
    
    #
    DEFAULT_TEMPLATE_PROCESSORS.each do |name|
      require File.join( File.dirname( __FILE__ ), name )
    end
  end
end
