dep 'juici configured' do
  requires "juici bundled",
           "mongodb.managed"
end

dep "juici running" do
  requires "juici bundled"
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
