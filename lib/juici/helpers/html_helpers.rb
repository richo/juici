require 'cgi'
def escaped(content)
  CGI.escapeHTML content
end
