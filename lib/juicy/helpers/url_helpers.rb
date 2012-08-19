def build_url_for(project)
  case project
  when String
    "/builds/#{project}"
  when ::Juicy::Project
    "/builds/#{project.name}"
  end
end
