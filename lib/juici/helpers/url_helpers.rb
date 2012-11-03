def build_url_for(entity)
  URI.escape case entity
  when String
    "/builds/#{entity}/list"
  when ::Juici::Project
    "/builds/#{entity.name}/list"
  when ::Juici::Build
    "/builds/#{entity[:parent]}/show/#{entity[:_id]}"
  end
end

def rebuild_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/#{entity[:parent]}/rebuild/#{entity[:_id]}"
  end
end

def kill_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/kill"
  end
end

def edit_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/#{entity[:parent]}/edit/#{entity[:_id]}"
  end
end
