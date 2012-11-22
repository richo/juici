def build_url_for(entity)
  URI.escape case entity
  when String
    "/builds/#{entity}/list"
  when ::Juici::Project
    "/builds/#{entity.name}/list"
  when ::Juici::Build
    "/builds/#{entity.name}/show/#{entity[:_id]}"
  end
end

def rebuild_url_for(entity)
  URI.escape case entity
  when ::Juici::Build # TODO ?
    "/builds/#{entity.name}/rebuild/#{entity[:_id]}"
  end
end

def kill_url_for(entity)
  URI.escape case entity
  when ::Juici::Build # TODO ?
    "/builds/kill"
  end
end

def cancel_url_for(entity)
  URI.escape case entity
  when ::Juici::Build # TODO ?
    "/builds/cancel"
  end
end

def edit_url_for(entity)
  URI.escape case entity
  when ::Juici::Build
    "/builds/#{entity.name}/edit/#{entity[:_id]}"
  end
end
