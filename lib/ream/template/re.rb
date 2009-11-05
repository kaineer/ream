#==============================================================
# module: Ream::Template::RE
#   date: 2009.11.05
#
#  brief: Taking care of template name/parameters placeholders
#==============================================================

module Ream
  module Template
    module RE
      #-------------------------------------------------------- 
      # PlaceHolderNamePart ::= \w+
      #
      # PlaceHolderName ::= PlaceHolderNamePart
      # PlaceHolderName ::= PlaceHolderName 
      #                     [.:] 
      #                     PlaceHolderNamePart
      #
      # TemplatePlaceHolder ::= { PlaceHolderName }
      #
      # ParameterPlaceHolder ::= % PlaceHolderName %
      #--------------------------------------------------------
      def self.expand_includes; /\{(\w+([.:]\w+)*)\}/; end
      def self.expand_params; /%(\w+([.:]\w+)*)%/; end
    end
  end
end
