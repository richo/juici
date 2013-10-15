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
  met? {
    shell?("bundle check")
  }
  meet {
    shell("bundle install")
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
