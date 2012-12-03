require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ::Juici::Router do
  it "should match for build_list" do
    route = Juici::Router.build_list_path
    should.should match ::Juici::Routes.build_list("fo/test/o")
  end

  it "should match for build_rebuild" do
    route = Juici::Router.build_rebuild_path
    route.should match ::Juici::Routes.build_rebuild("fo/test/o", "test")
  end

  it "should match for build_edit" do
    route = Juici::Router.build_edit_path
    route.should match ::Juici::Routes.build_edit("fo/test/o", "test")
  end

  it "should match for build_show" do
    route = Juici::Router.build_show_path
    route.should match ::Juici::Routes.build_show("fo/test/o", "test")
  end

  it "should match for build_trigger" do
    route = Juici::Router.build_trigger_path
    route.should match ::Juici::Routes.build_trigger("fo/test/rawr")
  end
end
