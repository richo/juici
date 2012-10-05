def build_url_for(project)
  URI.escape case project
  when String
    "/builds/#{project}/list"
  when ::Juici::Project
    "/builds/#{project.name}/list"
  end
end
