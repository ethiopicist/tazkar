require "octokit" if Jekyll::env == "production"
require "cff"

Jekyll::Hooks.register :site, :pre_render do |site|
  
  site.data["authors"] = CFF::File.read('CITATION.cff').authors.map(&:fields)
  
end

Jekyll::Hooks.register :site, :pre_render do |site|

  if Jekyll::env == "production" then git = Octokit::Client.new(:access_token => ENV["GH_TOKEN"]) end

  site.config["last_modified"] = DateTime.now.to_s

end