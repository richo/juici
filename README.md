## Juicy

Juicy is a CI server that has a notion of queuing and priority.

It's designed to work well with [agent99](https://github.com/99designs/agent99) but will play nicely with most frontends to CI.

## Features

* callbacks are created as builds are requested
* Builds are executed sequentially in a series of parallel queues.
* Queues can be dynamically created
* Build status visualised

## Setup

Juicy is deliberately very light on the setup front.

```bash

bundle install
bundle exec juicy
```

is all you need to have a working instance (provided that you have mongo installed)

## Usage

Juicy chooses to be very "Mongo" (which is an adjective now), in that you don't
need to formally create a project. Just request a build; however this means
that on your first build you will need to send the commands to create your test
environment)

Example:

```bash

curl --data-ascii @/dev/stdin <<EOF
payload={"environment":{
"SHA1":"e8b179f75bbc8717c948af052353424d458af981"},
"command":"[ -d .git ] || (git init .; git remote add origin git://github.com/richo/twat.git); git fetch; git checkout $SHA1; bundle install; bundle exec rake spec"
EOF
```

Using a convention like `script/cibuild` as in janky/hubot etc is advisable,
although bear in mind that the logic to checkout the repo will need to be
seperate.

## Priority

Juicy supports the notion of priority. Builds given without a priority will be
assigned priority 1 (to allow for marking a build as less important with
priority 0).

If juicy recieves a new build with priority higher than any currently
unfinished, it will pause whatever it's doing and build the new project. If
there is a tie for priority, a FIFO queue is assumed.

Juicy uses `SIGSTOP` and `SIGCONT` internally for job control.

## Hooks

You may specify one or more callbacks when you request a build. They will be
called with an (as yet unformalised) json body as the body if/when the build
reaches that state. Alternately you may specify "any" as the callback state and
it will be called on all state changes.

## Security

Juicy poses some interesting security conecerns. First off, it will allow
anyone with access to run arbitrary commands on your server. I have
deliberately not implemented any kind of security inside Juicy, it plays nicely
as a Rack application, and middlewares are much better suited to this task.

It should go without saying, but any builds started by Juicy will inherit it's
environment. This means that if you run it in dev mode and forward your ssh
agent, builds can ssh to other machines as you!

When running in production you should take steps to ensure that the user Juicy
runs as is no more privileged than it needs to be, and sanitise it's
environment before execution.
