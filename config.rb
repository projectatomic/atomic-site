# -*- coding: utf-8 -*-
###
# Site settings
###

# Look in data/site.yml for general site configuration

Time.zone = data.site.timezone || 'UTC'

# Admin needs i18n turned on for time_ago_in_words
activate :i18n, langs: [:en]

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Syntax highlighting
activate :syntax

# Make URLs relative
set :relative_links, true

# Set HAML to render HTML5 by default (when unspecified)
# It's important HAML outputs "ugly" HTML to not mess with code blocks
set :haml, format: :html5, ugly: true

# Set Markdown features for RedCarpet
# (So our version of Markdown resembles GitHub's)
set :markdown,
    autolink: true,
    fenced_code_blocks: true,
    footnotes: true,
    gh_blockcode: true,
    highlight: true,
    no_intra_emphasis: true,
    quote: true,
    smartypants: true,
    strikethrough: true,
    superscript: true,
    tables: true

set :markdown_engine, :redcarpet

set :asciidoc_attributes, %w(source-highlighter=coderay imagesdir=images)

set :asciidoctor,
    toc: true,
    numbered: true

# Set directories
set :css_dir, 'stylesheets'
set :fonts_dir, 'stylesheets/fonts'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'layouts'

###
# Blog settings
###

activate :blog do |blog|
  blog.prefix = 'blog/'
  blog.layout = 'post'
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
  blog.default_extension = '.md'

  blog.sources = ':year-:month-:day-:title.html'
  # blog.permalink = ":year/:month/:day/:title.html"
  blog.permalink = ':year/:month/:title.html'
  blog.year_link = ':year.html'
  blog.month_link = ':year/:month.html'
  # blog.day_link = ":year/:month/:day.html"

  blog.taglink = 'tag/:tag.html'

  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 99999

  blog.paginate = true
  blog.per_page = 5
  blog.page_link = 'page=:num'
end

# activate :authors
# activate :drafts

# Enable blog layout for all blog pages
with_layout :post do
  page '/blog.html'
  page '/blog/*'
end

# Make pretty URLs
activate :directory_indexes

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Don't have a layout for XML
page '*.xml', layout: false

# Docs all have the docs layout
with_layout :docs do
  page "/docs/*"
  page "/docs*"
end

# Don't make these URLs have pretty URLs
page '/404.html', directory_index: false
page '/.htacces.html', directory_index: false

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

proxy '/.htaccess', '/.htaccess.html', locals: {}, ignore: true

ready do
  # Add author pages
  sitemap.resources.group_by { |p| p.data['author'] }.each do |author, pages|
    next unless author

    proxy "/blog/author/#{author.parameterize.downcase}.html",
          'author.html',
          locals: { author: author, pages: pages },
          ignore: true
  end

  proxy '/blog/author.html', 'author.html', ignore: true

  # Add blog feeds
  blog.tags.each do |tag_name, _tag_data|
    next unless tag_name

    proxy "/blog/tag/#{tag_name.downcase.parameterize}.xml",
          'feed.xml',
          locals: { tag_name: tag_name },
          ignore: true
  end

  proxy '/blog/feed.xml', 'feed.xml', ignore: true
  proxy '/blog/tag/index.html', 'tag.html', ignore: true
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end
# helpers do
# end

require 'lib/site_helpers.rb'
activate :site_helpers

require 'lib/blog_helpers.rb'
activate :blog_helpers

require 'lib/monkeypatch_blog_date.rb'

activate :piwik do |f|
    f.id = 4
    f.domain = 'tracker.osci.io'
    f.url = 'piwik'
end

###
# Development-only configuration
###
#
configure :development do
  puts "\nUpdating git submodules..."
  puts `git submodule init && git submodule sync`
  puts `git submodule foreach "git pull -qf origin master"`
  puts "\n"
  puts '== Administration is at http://0.0.0.0:4567/admin/'

  activate :livereload
  # config.sass_options = {:debug_info => true}
  # config.sass_options = {:line_comments => true}
  compass_config do |config|
    config.output_style = :expanded
    config.sass_options = { debug_info: true, line_comments: true }
  end
end

# Build-specific configuration
configure :build do
  puts "\nUpdating git submodules..."
  puts `git submodule init`
  puts `git submodule foreach "git pull -qf origin master"`
  puts "\n"

  ## Ignore administration UI
  ignore '/admin/*'
  ignore '/javascripts/admin*'
  ignore '/stylesheets/lib/admin*'

  ## Ignore Gimp source files
  ignore 'images/*.xcf*'

  # Don't export source JS
  ignore 'javascripts/vendor/*'
  ignore 'javascripts/lib/*'

  # Don't export source CSS
  ignore 'stylesheets/vendor/*'
  ignore 'stylesheets/lib/*'

  ignore 'events-yaml*'

  # Minify JavaScript and CSS on build
  activate :minify_javascript
  activate :minify_css
  # activate :gzip

  # Force a browser reload for new content by using
  # asset_hash or cache buster (but not both)
  activate :cache_buster
  # activate :asset_hash

  # Use relative URLs for all assets
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"

  # Favicon PNG should be 144×144 and in source/images/favicon_base.png
  # Note: You need ImageMagick installed for favicon_maker to work
  activate :favicon_maker do |f|
    f.template_dir  = File.join(root, 'source', 'images')
    f.output_dir    = File.join(root, 'build', 'images')
    f.icons = {
      'favicon_base.png' => [
        { icon: 'favicon.png', size: '16x16' },
        { icon: 'favicon.ico', size: '64x64,32x32,24x24,16x16' }
      ]
    }
  end
end

###
# Deployment
##

if data.site.openshift
  os_token, os_host = data.site.openshift.match(/([0-9a-f]+)@([^\/]+)/).captures

  deploy_config = {
    method: :rsync,
    user: os_token,
    host: os_host,
    path: "/var/lib/openshift/#{os_token}/app-root/repo",
    clean: true, # remove orphaned files on remote host
    build_before: true # default false
  }

elsif data.site.rsync
  rsync = URI.parse(data.site.rsync)

  deploy_config = {
    method: :rsync,
    user: rsync.user || ENV[:USER],
    host: rsync.host,
    path: rsync.path,
    port: rsync.port || 22,
    clean: true, # remove orphaned files on remote host
    build_before: true # default false
  }

else
  # For OpenShift,
  #
  # 1) use the barebones httpd cartridge from:
  #    http://cartreflect-claytondev.rhcloud.com/reflect?github=stefanozanella/openshift-cartridge-httpd
  #    (Add as URL at the bottom of the create from cartridge page)
  #
  # 2) Copy your new site's git repo URL and use it for 'production':
  #    git remote add production OPENSHIFT_GIT_REMOTE_HERE
  #
  # 3) Now, you can easily deploy to your new OpenShift site!
  #    bundle exec middleman deploy

  deploy_config = {
    method: :git,
    remote: 'production',
    branch: 'master',
    build_before: true # default false
  }
end

activate :deploy do |deploy|
  deploy_config.each { |key, val| deploy[key] = val }
end
