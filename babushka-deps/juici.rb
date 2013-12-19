dep 'juici configured' do
  requires "juici bundled",
           "mongodb.managed"
end

dep "juici running" do
  requires "juici bundled",
           "juici.supervisor"
end

dep 'juicic.bin' do
  requires 'juici-interface.gem'
end

dep "juici bundled" do
  requires 'ruby1.9.3.managed',
           'ruby1.9.1-dev.managed',
           'ruby-bundler.managed'
  met? {
    shell?("ruby1.9.3 /usr/bin/bundle check")
  }
  meet {
    sudo("ruby1.9.3 /usr/bin/bundle install")
  }
end

dep "juici.supervisor" do
  command "bundle exec bin/juici"
  directory Dir.pwd()
  num_procs 1
  environment({
    "RACK_ENV" => 'production',
    "PORT" => '9000',
    "PATH" => "/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "HOME" => Dir.pwd(),
    "LANG" => "en_US.UTF-8"
  })
end

dep "mongodb.managed" do
  provides "mongo"
end

dep 'ruby1.9.3.managed' do
  provides "ruby1.9.3"
end
dep 'ruby1.9.1-dev.managed' do
  requires 'build-essential.managed'
  provides []
end
dep 'ruby-bundler.managed' do
  provides ['bundle']
end


dep 'build-essential.managed' do
  ## Don't reference a particular compiler, they're all good
  provides ['make']
end
