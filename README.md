## Juicy

Juicy is a CI server that has a notion of queuing and priority.

It's designed to work well with [agent99](https://github.com/99designs/agent99) but will play nicely with most frontends to CI.

## Features

* callbacks are created as builds are requested
* Builds are executed sequentially in a series of parallel queues.
* Queues can be dynamically created
