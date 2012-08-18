def project_url_for(project)
  if project.nil?
    "/projects"
  else
    "/builds/#{project}"
  end
end
