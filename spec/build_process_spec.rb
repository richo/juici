require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juici build abstraction" do

  before(:all) do
    @app = Juici::App.new
  end

  after(:all) do
    Juici::App.shutdown
  end


  it "Should run a given command in a subshell" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "/bin/echo 'test build succeeded'")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    Timeout::timeout(2) do
      poll_build(build)

      build.reload
      build.status.should == Juici::BuildStatus::PASS
      build[:output].chomp.should == "test build succeeded"
    end
  end

  it "Should respect shebang lines" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "#!/bin/cat")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    Timeout::timeout(2) do
      poll_build(build)

      build.reload
      build.status.should == Juici::BuildStatus::PASS
      build[:output].chomp.should == "#!/bin/cat"
    end
  end

  it "Should handle whitespace in shebang lines" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "#!/usr/bin/env echo buttslol")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    Timeout::timeout(2) do
      poll_build(build)

      build.reload
      build.status.should == Juici::BuildStatus::PASS
      build[:output].chomp.should == "buttslol"
    end
  end

  it "Should catch failed builds" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "exit 3")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    Timeout::timeout(2) do
      poll_build(build)

      build.reload
      build.status.should == Juici::BuildStatus::FAIL
      build[:output].chomp.should == ""
    end
  end

  it "Should kill builds" do
    build = Juici::Build.new(parent: "test",
                             command: "sleep 30")
    $build_queue << build
    sleep 1
    build.kill!

    build.reload

    build.status.should == Juici::BuildStatus::FAIL
    build.warnings.should include("Killed!")
  end

  it "Can create and fetch new bundles" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                             environment: ::Juici::BuildEnvironment.new.to_hash,
                             command: <<-EOS)
#!/bin/sh
set -e

cat > Gemfile <<EOF
source :rubygems
gem "m2a"
EOF

env

bundle install
bundle list
bundle config
EOS

    build.save!
    $build_queue << build

    Timeout::timeout(10) do
      poll_build(build)

      build.status.should == Juici::BuildStatus::PASS
      build[:output].chomp.should match /m2a/
    end
  end

end
