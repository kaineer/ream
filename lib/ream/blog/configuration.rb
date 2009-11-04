#===============================================================
#
#
#
#
#===============================================================

=begin
\ - HOME_ROOT
:-\ - scripts      # for generating processors, templates and pages, and building of www
:-\ - config
: :-\ - processors # template processors (.rb)
: :-\ - templates  # design templates (.tpl)
:-\ - public
: :-\ - images
: :-\ - stylesheets
: :-\ - javascripts
:-\ - pages        # here and lower - page structure (.)
:-\ - www          # to keep build results
=end

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
