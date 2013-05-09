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

  it "Should respect shebang line arguments" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "#!/bin/cat -b")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    Timeout::timeout(2) do
      poll_build(build)

      build.reload
      build.status.should == Juici::BuildStatus::PASS
      build[:output].strip.should == "1\t#!/bin/cat -b"
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
    pending
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

  it "should queue builds for the same project" do
    watcher = Juici::Watcher.instance.start
    build1 = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "sleep 10")
    build2 = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "sleep 10")

    build1.save
    build2.save

    $build_queue << build1
    $build_queue << build2

    build1.status.should == Juici::BuildStatus::START
    build2.status.should == Juici::BuildStatus::WAIT

    build1.kill!
    poll_build(build1)

    build2.status.should == Juici::BuildStatus::START

    build2.kill!
    poll_build(build2)
  end

  it "should build different projects simultaneously" do
    watcher = Juici::Watcher.instance.start
    build1 = Juici::Build.new(parent: "test project1",
                      environment: {},
                      command: "sleep 10")
    build2 = Juici::Build.new(parent: "test project2",
                      environment: {},
                      command: "sleep 10")

    build1.save
    build2.save

    $build_queue << build1
    $build_queue << build2

    build1.status.should == Juici::BuildStatus::START
    build2.status.should == Juici::BuildStatus::START

    build1.kill!
    poll_build(build1)

    build2.status.should == Juici::BuildStatus::START

    build2.kill!
    poll_build(build2)
  end

end
