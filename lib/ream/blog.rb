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
=begin
Page is a file with
  * Page hierarchy (breadcrumb)
  * Page environment (parameters for replacing %placeholders%)
--- yaml:parametrs
title: This page title
date: 2009.XX.XX              - when page was created
--- yaml:environment
tags: [work, ruby, bdd]
templates: [empty]            - templates to build page with
---


=end



require 'ream/blog/node'
require 'ream/blog/page'
require 'ream/blog/parameters'
#require 'ream/blog/processor'
require 'ream/blog/template_processor'

require 'ream/blog/overrides'
