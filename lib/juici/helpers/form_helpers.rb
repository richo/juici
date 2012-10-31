def form_at(route, fields, opts={})
  form = ""
  form << %Q{<form class="well" action="#{route}" method="post">\n}

  fields.each do |name, value|
    form << %Q{<input type="hidden" name="#{name}" value="#{value}">\n}
  end

  form << %Q{<button type="submit" class="btn">#{opts[:submit] || "submit"}</button>}
end
