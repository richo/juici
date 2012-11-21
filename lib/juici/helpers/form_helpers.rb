def form_at(route, fields, opts={})
  form = ""
  form << %Q{<form action="#{route}" method="#{opts[:method] || "post"}">\n}

  fields.each do |name, value|
    form << %Q{<input type="hidden" name="#{name}" value="#{value}">\n}
  end

  yield form if block_given?

  unless opts[:no_submit]
    form << %Q{<button type="submit" class="btn">#{opts[:submit] || "submit"}</button>}
  end
  form << %Q{</form>}
end
