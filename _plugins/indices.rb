module ListPages

  class MonthPageGenerator < Jekyll::Generator

    def generate(site)

      (1..13).each do |month|
        site.pages << MonthPage.new(site, month)
      end

    end

  end

  class MonthPage < Jekyll::Page
    def initialize(site, month)

      mm = month.to_s.rjust(2, "0")

      localizedDir = site.config["collections"]["commemorations"]["permalink"].match(/\/(.+?)\/.+/)[1]

      @site = site
      @base = site.source
      @dir  = "#{localizedDir}/#{mm}"

      @basename = "index"
      @ext      = ".html"
      @name     = "index.html"

      @data = {
        "layout" => "month_day",
        "localizations" => site.data["locale"].map{ |locale| {"locale" => locale[0], "url" => "#{locale[0]}/#{locale[1]["meta"]["commemorations"]}/#{mm}/"}},
        "title" => site.data["locale"]["gez"]["months"][month-1],
        "month" => month,
        "commemorations" => site.collections["commemorations"].docs.select{ |commemoration| commemoration.path.match?(/commemorations\/#{mm}/) }
      }

    end

    def url_placeholders
      {
        :path       => @dir,
        :basename   => basename,
        :output_ext => output_ext,
      }
    end
  end

  class DayPageGenerator < Jekyll::Generator

    def generate(site)

      (1..13).each do |month|
        (1..30).each do |day|
          break if month == 13 && day > 6
          site.pages << DayPage.new(site, month, day)
        end
      end

    end

  end

  class DayPage < Jekyll::Page
    def initialize(site, month, day)

      mm = month.to_s.rjust(2, "0")
      dd = day.to_s.rjust(2, "0")

      localizedDir = site.config["collections"]["commemorations"]["permalink"].match(/\/(.+?)\/.+/)[1]

      @site = site
      @base = site.source
      @dir  = "#{localizedDir}/#{mm}/#{dd}"

      @basename = "index"
      @ext      = ".html"
      @name     = "index.html"

      @data = {
        "layout" => "month_day",
        "localizations" => site.data["locale"].map{ |locale| {"locale" => locale[0], "url" => "#{locale[0]}/#{locale[1]["meta"]["commemorations"]}/#{mm}/#{dd}/"}},
        "title" => "#{day} #{site.data["locale"]["gez"]["months"][month-1]}",
        "month" => month,
        "day" => day,
        "commemorations" => site.collections["commemorations"].docs.select{ |commemoration| commemoration.path.match?(/commemorations\/#{mm}\/#{dd}/) }
      }

    end

    def url_placeholders
      {
        :path       => @dir,
        :basename   => basename,
        :output_ext => output_ext,
      }
    end
  end

  class SubjectListPageGenerator < Jekyll::Generator

    def generate(site)

      localizedDir = site.config["collections"]["subjects"]["permalink"].match(/\/(.+?)\/.+/)[1]
      
      site.pages << Jekyll::PageWithoutAFile.new(site, site.source, localizedDir, "index.html").tap do |page|
        
        page.data = {
          "layout" => "subject_list",
          "localizations" => site.data["locale"].map{ |locale| {"locale" => locale[0], "url" => "#{locale[0]}/#{locale[1]["meta"]["subjects"]}/"}},
          "subjects" => site.collections["subjects"].docs
        }

      end

    end

  end

end