* This awkward `::Juici::Model` kludge inside views is a pain.

* RSS feed for build status (spyware)

* Paginated builds to avoid blocking up a connection

* Proper callback support

* Graphing of build times and statuses

* Search

## Only child model

`lib/juici/watcher +21`

Basically, it would be nice to have a watcher get started with the first build
out of the ranks, and then die on ECHILD

This means that with lots of builds passing through we can retain a single
watcher, and when we're idle we let him die and then spawn a new one when we
need

* Neat method of either resuming or starting a build

* RSS api

* Import of Xdefaults/itermcolors.plist for output colors

## Postable routes

* /$entity/:instance/_action

