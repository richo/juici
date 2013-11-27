# Hacking on Juici

If you use this precise64 box with RVM and Ruby pre-installed, so all you need to do is install Babushka, a few dependencies, and run the included deps.

First, download and add the box (~700MB):

`vagrant box add precise64ruby2 https://s3.amazonaws.com/99designs-vagrant-boxes/precise64_ruby2.box`

Now:

`vagrant init`

Edit the `Vagrantfile` and use the box you just added:

`config.vm.box = "precise64ruby2"`

Also share the current dir with the guest:

`config.vm.synced_folder "../juici", "/home/vagrant/juici"`

Also forward JuiCI's http port:

`config.vm.network "forwarded_port", guest: 9000, host: 8080`

Now spin up the box and get a shell:

`vagrant up && vagrant ssh`

We'll need Babushka so we can run the deps:

`wget -O - https://s3.amazonaws.com/99designs-babushka/bootstrap | bash`

You might need to change the permissions of `/usr/local/babushka` and `/usr/local/bin` so that the
installer can write the files and create the symlinks for the `vagrant` user.

Then you'll need to install bundler:

`sudo apt-get install ruby-bundler`

Then:

`gem install bundler`

Now we are ready to run the configuration deps:

`babushka 'current dir:juici configured'`

Finally, we can start the application with:

`bundle exec bin/juici`
