require "date"
require_relative "ethiopic"
include Jekyll::Ethiopic

module Jekyll::Localization
  
  def localize(path)
    
    path = path.split(".")
    locale = @context.registers[:site].config["locale"]

    @context.registers[:site].data["locale"][locale].dig(*path)

  end

  def locale_date(input)

    "#{input.day} #{localize("months.#{input.month}")}"

  end

  def possessive(input)

    #case locale

  end

end

Liquid::Template.register_filter(Jekyll::Localization)

Jekyll::Hooks.register :site, :pre_render do |site|
  if site.config["locale"] == "am"
    site.data["locale"]["gez"]["months"].map!{ |month| fidal(month).delete("፡") }
  end
end