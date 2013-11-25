## JuiCI

JuiCI is a CI server that has a notion of queuing and priority.

It's designed to work well with [agent99](https://github.com/99designs/agent99)
but will play nicely with most frontends to CI.

## Features

* Callbacks are created as builds are requested
* Builds are executed in parallel, with one concurrent build per workspace
* Queues can be dynamically created
* Build status visualised

## Important but Miscellaneous

If you create child processes in modules/plugins then you need to register your
disinterest or JuiCI will think they're builds and that would be bad.

## Setup

JuiCI is deliberately very light on the setup front.

```bash
bundle install
bundle exec bin/juici
```

is all you need to have a working instance (provided that you have mongo installed).

### Gotchas

Make sure you don't do something innocuous like

```bash
bundle install --path .bundle
```

this might look sane (and it is, kinda) but owing to a quirk in bundler, it
will break any ruby code you try to build.

I'm working on a workaround, but in the meantime the fix is to not do it!

## Usage

JuiCI is very focused on minimal configuration; meaning that beyond starting
the server and pointing it at a MongoDB instance, you do not need to do
anything special to build a new project. Just request a build; however this
means that on your first build you will need to send the commands to create
your test environment)

There is a sample implementation of a JuiCI client bundled with the JuiCI source
code, or exposed in the `juici-interface` gem.

Example:

```bash
juicic build --host $hostname --command - --title "test build" \
             --project "some project" <<EOF
if [ ! -d .git ]; then
  git init .
  git remote add origin git://github.com/richo/twat.git
fi

git fetch
git checkout -fq origin/master

set -e

bundle install
bundle exec rake spec"
EOF
```

Using a convention like `script/cibuild` as in janky/hubot etc is advisable,
although bear in mind that the logic to checkout the repo will need to be
seperate.

## Priority

JuiCI supports the notion of priority. Builds given without a priority will be
assigned priority 1 (to allow for marking a build as less important with
priority 0).

If juici receives a new build with priority higher than any currently
unfinished, it will pause whatever it's doing and build the new project. If
there is a tie for priority, a FIFO queue is assumed.

JuiCI uses `SIGSTOP` and `SIGCONT` internally for job control.

## Hooks

You may specify one or more callbacks when you request a build. They will be
called with an (as yet unformalised) json body as the body if/when the build
reaches that state. Alternately you may specify "any" as the callback state and
it will be called on all state changes.

## Integration

Apps written in ruby wanting to interact with Juici can include the
`juici-interface` gem, which presently exposes a few constants to line up with
JuiCI's internal state.
Over time this will be expanded, but for now they are:

```ruby
Juici::BuildStatus::PASS
Juici::BuildStatus::FAIL
Juici::BuildStatus::START
Juici::BuildStatus::WAIT
```

## Security

JuiCI poses some interesting security concerns. First off, it will allow
anyone with access to run arbitrary commands on your server. I have
deliberately not implemented any kind of security inside JuiCI, it plays nicely
as a Rack application, and middlewares are much better suited to this task.

It should go without saying, but any builds started by JuiCI will inherit its
environment. This means that if you run it in dev mode and forward your ssh
agent, builds can ssh to other machines as you!

When running in production you should take steps to ensure that the user JuiCI
runs as is no more privileged than it needs to be, and sanitise its
environment before execution.

## A note on subprocesses

JuiCI by default invokes everything in a subshell - indeed this is the only way
to approach this if you want to execute more than one command.

What this means to you as the user though is that unless you go to lengths to
specifically implement it, your process won't see any of the signal handling
madness. The shell(`/bin/sh`) will see everything, and if killed, your
processes will become orphaned, but carry on.

## Authors

* [Richo Healey](https://github.com/rcho)
* [Alec Sloman](https://github.com/alecsloman)

## Contact

JuiCI's code lives on [Github](https://github.com/richo/juici)
and the [author](mailto:richo@psych0tik.net) can be contacted on
 [Twitter](https://twitter.com/rich0H)

## Legalese

(c) Richo Healey 2012, richo@psych0tik.net

Released under the terms of the MIT license.
