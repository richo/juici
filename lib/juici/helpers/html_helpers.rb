require 'cgi'
def escaped(content)
  CGI.escapeHTML content.encode("UTF-8")
end
