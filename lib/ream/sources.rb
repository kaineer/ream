# Some classes can be used as `sources' 
# After initialization, sources object can be called with #each method
# in hash-like manner:
#  source_iterator.each {|key, value| ... }

require 'ream/sources/fs'
require 'ream/sources/url'
