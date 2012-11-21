require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "form_helper" do
  extend Juici::Helpers

  describe "form_at" do
    it "should set the action" do
      form = form_at "blah thing", []
      form.should include('action="blah thing"')
    end
    it "should post by default" do
      form = form_at "foo", []
      form.should include('method="post"')
    end
    it "should allow different methods" do
      form = form_at "foo", [], method: "get"
      form.should include('method="get"')
    end
    it "should include hidden fields" do
      form = form_at "foo", [["foo", "bar"]]
      form.should include('<input type="hidden" name="foo" value="bar">')
    end
    it "should yield the form" do
      input = '<input type="blah">'
      form = form_at("foo", []) do |f|
        f << input
      end

      form.should include(input)
    end
  end
end
