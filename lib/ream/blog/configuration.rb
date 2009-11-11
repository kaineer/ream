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
      #
      def self.templates_root; "config/templates"; end
      def self.pages_root; "pages"; end
      def self.output_root; "www"; end
      def self.processors_root; "config/processors"; end
      def self.main_template; "html:page"; end
      def self.page_content_part; "content"; end
      #
    end
  end
end
