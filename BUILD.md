# Building the Website

This website is built on [Middleman, a static site generator](https://middlemanapp.com). See instructions below for building it.

## Atomic.app

The recommended way to test the site is with [atomic.app](https://github.com/projectatomic/atomicapp). Currently, version 0.4.2 or later is required.

### First time setup

The first time you run it with Atomic App, you'll need to generate an answers.conf
file with information it needs to launch the container. You shouldn't have to
do this on successive runs unless you delete the answers.conf file for some
reason.

1. Generate answer.conf file:

   ```
   cd /path/to/atomic-site/Nulecule/
   atomicapp genanswers .
   ```

2. Edit answers.conf to match your setup.

For answers.conf, the two things you are required to set is the full path
to the two directories, /source and /data.  These should point to the absolute path to `atomic-site/source`
and `atomic-site/data` directories on your computer.  For example: `/home/josh/git/atomic-site/source`.
The other fields should not require modification for most people.

### Running the atomic.app

Once you are done with the setup, you should be able to do this to run the container
each time and test the atomic site by running from the repository's root:

```
cd /path/to/atomic-site/
sudo atomicapp run Nulecule/
```

The first time you do this, it will pull the atomic-site image, which may take
a while depending on your internet connection.  After that it should be very fast.

Once it's running, you can view the site on [127.0.0.1:4567](http://127.0.0.1:4567).

## Docker build

The second way to build the site is using Docker without atomic.app. From the repo's
root directory, run the docker build:

```
./docker.sh
```

If your local machine has Docker secured, then you'll need to sudo the above command.

Once the container is up and running, the site will be available on [127.0.0.1:4567](http://127.0.0.1:4567).

Note that `docker.sh` builds the site's image every time it runs due to cache issues. This may take a significant amount of time on slower machines.

## Manual Build

If you don't want to use the Atomic App or Docker containers for some reason,
you can follow below instructions to build the site manually.

To get started, you need to have Ruby and Ruby Gems installed, as well
as "bundler".


### Initial setup

On a rpm based distribution:

```
git clone http://github.com/projectatomic/atomic-site.git
cd atomic-site
./setup.sh # This script assumes your user account has sudo rights
```

### Running a local server

1. Start a local Middleman server:

   `./run-server.sh`

   This will update your locally installed gems and start a Middleman
   development server.

2. Next, browse to <http://0.0.0.0:4567>

3. Edit!

   Note, when you edit files (pages, layouts, CSS, etc.), the site will
   dynamically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


### Updating

When there are new gems in `Gemfile`, just run `bundle` again.

### Customizing your site

The site can be customized by editing `data/site.yml`.

### Adding a Post

To add a post to the community blog (or any blog managed by Middleman) use:

```
bundle exec middleman article TITLE
```

### Build your static site

You can build the static site by running:

`bundle exec middleman build`


## Deploying

### Setting up deployment

FIXME: Right now, please reference [data/site.yml](data/site.yml)

### Actual deployment

After copying your public key to the remote server and configuring your
site in [data/site.yml](data/site.yml), deployment is one command:

```
bundle exec middleman deploy
```


### Add new features (parsers, etc.)

Simply add a new `gem 'some-gem-here'` line in the `Gemfile` and run
`bundle install`


## More info

For more information, please check the excellent
[Middleman documentation](https://middlemanapp.com/basics/install/).
