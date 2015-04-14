# Atomic project website

This website is built on Middleman, a static site generator. See below for
quick instructions:

To get started, you need to have Ruby and Ruby Gems installed, as well
as "bundler".


## Initial setup

On an rpm based distribution:

```
git clone http://github.com/projectatomic/atomic-site.git
cd atomic-site
./setup.sh # This script assumes your user account has sudo rights
```


## Running a local server

1. Start a local Middleman server:

   `./run-server.sh`

   This will update your locally installed gems and start a Middleman
   development server.

2. Next, browse to <http://0.0.0.0:4567>

3. Edit!

   When you edit files (pages, layouts, CSS, etc.), the site will
   dynamically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


## Updating

When there are new gems in `Gemfile`, just run `bundle` again.


## Customizing your site

The site can be easily customized by editing `data/site.yml`.


## Adding a Post

To add a post to the community blog (or any blog managed by middleman) use:

```
bundle exec middleman article TITLE
```


## Build your static site

After getting it how you want, you can build the static site by running:

`bundle exec middleman build`


## Deploying

### Setting up deployment

FIXME: Right now, please reference <data/site.yml>

### Actual deployment

After copying your public key to the remote server and configuring your
site in <data/site.yml>, deployment is one simple command:

```
bundle exec middleman deploy
```


### Add new features (parsers, etc.)

Simply add a new `gem 'some-gem-here'` line in the `Gemfile` and run
`bundle install`


## More info

For more information, please check the excellent
[Middleman documentation](https://middlemanapp.com/basics/install/).
