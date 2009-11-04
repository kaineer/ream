### Ream::Template
$:.unshift( File.join( File.dirname( __FILE__ ), "../../ream/lib" ) )
### Ream::Blog::*
$:.unshift( File.join( File.dirname( __FILE__ ), "../lib" ) )

require 'rubygems'
require 'test/unit'
require 'mocha'

require 'ream/blog'
require File.join( File.dirname( __FILE__ ), 'suite/utils' )

Dir[ "**/test_*.rb" ].each { |fn| require fn } if $0 == __FILE__
