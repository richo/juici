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

def form_at(route, fields, opts={})
  form = ""
  form << %Q{<form class="well" action="#{route}" method="post">\n}

  fields.each do |field|
    form << %Q{<input type="hidden" name="#{field[:name]}" value="#{field[:value]}">\n}
  end

  form << %Q{<button type="submit" class="btn">#{opts[:submit] || "submit"}</button>}
end
