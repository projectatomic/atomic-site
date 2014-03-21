# Atomic project website

  * Atomic is a not-yet-public project.
  * https://mojo.redhat.com/groups/appinfra-project-glow

This website is build on Middleman, a static site generator. See below for 
quick instructions:

To get started, you need to have Ruby and Ruby Gems installed, as well
as "bundler".

## Initial setup

```
sudo yum install -y ruby-devel rubygems gcc-c++ curl-devel rubygem-bundler
git clone git@gitlab.osas.lab.eng.rdu2.redhat.com:osas/atomic-site.git
cd atomic-site
bundle install
```

## Usage

### View locally

1. Start up Middleman by typing `bundle exec middleman` (or if you have
   it in your path, just `middleman` works).
   
   Middleman will start up a development server. 

2. Next, browse to <http://0.0.0.0:4567>

3. Edit! 

   When you edit files (pages, layouts, CSS, etc.), the site will
   dyanmically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


### Build your static site

After getting it how you want, you can build the static site by running:

`bundle exec middleman build`

(If you have middleman in your path, you can just run `middleman build`.)


### Add new parsers

Simply add a new `gem 'some-gem-here'` line in the `Gemfile` and run
`bundle install`

## More info

For more information, please check the excellent 
[Middleman documentation](http://middlemanapp.com/getting-started/).
