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

def form_at(route, fields, opts={})
  form = ""
  form << %Q{<form action="#{route}" method="post">\n}

  fields.each do |field|
    form << %Q{<input type="hidden" name="#{field[:name]}" value="#{field[:value]}">\n}
  end

  form << %Q{<button class="juici-button" style="width:100%" type="submit">#{opts[:submit] || "submit"}</button>}
end
