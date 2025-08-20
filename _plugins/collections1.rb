require_relative "ethiopic"
include Jekyll::Ethiopic

Jekyll::Hooks.register :site, :pre_render do |site|
site.collections['subjects'].docs.each do |subject|
  
  if subject.data.key? "community"
    subject.data["communities"] = subject.data["community"]
  end
  
  if subject.data.key? "communities"
    
    subject.data["communities"] = Array(subject.data["communities"])
    
    belongs_to = {
      "gez" => "za-",
      "en" => "of ",
      "fr" => "de "
    }
    
    subject.data["name"].each do |locale, name|
      
      community = site.data["communities"][ subject.data["community"] ]
      
      subject.data["name"][locale] = "#{name} #{belongs_to[locale]}#{community}"
      
    end
    
  end
  
  subject.data["name"]["am"] = fidal(subject.data["name"]["gez"]).delete("፡")
  
end
end

Jekyll::Hooks.register :site, :pre_render do |site|
site.collections['commemorations'].docs.each do |commemoration|

  commemoration.data["uid"] =  commemoration.path.match(/(\d{2})\/(\d{2})\/(\d{2})/).to_a.drop(1).join

  # Use array [mm, dd] from path for day
  commemoration.data["date_array"] = commemoration.path.match(/(\d{2})\/(\d{2})\/\d{2}/).to_a.drop(1)
  commemoration.data["month"] = commemoration.data["date_array"][0]
  commemoration.data["day"] = commemoration.data["date_array"][1]

  if commemoration.data.key? "subject"
    commemoration.data["subjects"] = commemoration.data["subject"]
  end
  commemoration.data["subjects"] = Array(commemoration.data["subjects"])

  subjects = commemoration.data["subjects"].map do |key|
    site.collections["subjects"].docs.find{ |subject| subject.data["slug"].to_i == key }
  end

  # Name of commemoration
  unless commemoration.data.key? "name" # If name unspecified, use type + subjects

    commemoration.data["name"] = {}

    site.data["locale"].each do |locale|
      type = locale[1]["commemoration_types"][commemoration.data["type"]]
      commemoration.data["name"][locale[0]] = possessive(type, subjects, locale[0], site.data["locale"][locale[0]]["joining_conjunction"])
    end

  else # If specified, replace & with name(s) of subject(s)

    unless commemoration.data["name"].key? "am"
      commemoration.data["name"]["am"] = fidal(commemoration.data["name"]["gez"]).delete("፡")
    end
    
    commemoration.data["name"].each do |locale, name|

      names = subjects.map{ |subject| subject.data["name"][locale]}.join(site.data["locale"][locale]["joining_conjunction"])
      commemoration.data["name"][locale] = name.gsub("&", names )
      
    end

  end

end
end

def possessive(thing, people, locale, joining_conjunction)

  names = people.map{ |person| person.data["name"][locale] }.join(joining_conjunction)
  genders = people.map{ |person| person.data["sex"] }

  case locale
    
  when "gez"
    thing = thing.sub(/(?<=[iāe])$/, "h")
    if genders.count == 1 # singular
      case genders[0]
      when "m"
        "#{thing}u la-#{names}"
      when "f"
        "#{thing}ā la-#{names}"
      end
    else                  # plural
      unless genders.uniq.size == 1 && genders[0] == "f"
        "#{thing}omu la-#{names}"
      else
        "#{thing}on la-#{names}"
      end
    end
  when "en"
    "#{thing} of #{names}"
  when "fr"
    "#{thing} de #{names}"
  when "am"
    "የ#{names} #{thing}"
  end

end