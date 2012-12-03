def build_url_for(entity)
  URI.escape case entity
  when String
    "/builds/#{entity}/list"
  when ::Juici::Workspace
    "/builds/#{entity.name}/list"
  when ::Juici::Build
    "/builds/#{entity[:workspace]}/show/#{entity[:_id]}"
  end
end

def rebuild_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/#{entity[:workspace]}/rebuild/#{entity[:_id]}"
  end
end

def kill_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/kill"
  end
end

def cancel_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/cancel"
  end
end

def edit_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/#{entity[:workspace]}/edit/#{entity[:_id]}"
  end
end
