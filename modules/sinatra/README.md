# Sinatra

This module is very specific to my way of doing things. It's almost
certainly not suitable for anyone else's use.

I write small websites as Sinatra applications. They have a
`Gemfile`, but in production, I don't use it. This is because some
of the gems are native extensions, so require a build environment
which does not exist on my live infrastructure. I build my own
"Omnibus" style Ruby, which I know contains all the gems my sites
may need. Thus the `Gemfile` is only used for development purposes.

Each site sits in a Github repo, and to install it, you just have to
clone.

Because I run on SmartOS, my sites are started from SMF. The
manifests are generated and imported just once by this module, and
they start the `default` instance on import.

## `init.pp`

Wrapper to call other classes.

## `params.pp`

Parameters common to all classes.

## `install.pp`

Installs the stuff that is needed by later manifests.

## `sites.pp`

Fetches the site(s) from Github, generates SMF manifest and installs
it.

## `nginx.pp`

Configures nginx to proxy the sites.
