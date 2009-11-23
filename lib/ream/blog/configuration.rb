#===============================================================
#
#
#
#
#===============================================================


module Ream
  #
  #
  module Blog
    #
    #
    module Configuration
      #
      def self.sources; "config/sources.tpl"; end
      def self.transformations; "config/transformations.tpl"; end
      def self.processors; "config/processors/**/*.rb"; end

      #
      #
      def self.pages_root; "pages"; end
      def self.output_root; "site"; end
      def self.processors_root; "config/processors"; end
      def self.main_template; "html:page"; end
      def self.page_content_part; "content"; end
      #
    end
  end
end
