module LocalizingPages

  class LocalizerGenerator < Jekyll::Generator

    def generate(site)

      site.collections.each do |name, collection|

        collection.docs.each do |doc|

          path = doc.path.match(/#{name}\/(.+).md/)[1]

          doc.data.merge!(
            "localizations" => site.data["locale"].map{ |locale| {"locale" => locale[0], "url" => "#{locale[0]}/#{locale[1]["meta"][name]}/#{path}/"}}
          )

        end

      end

    end

  end

end