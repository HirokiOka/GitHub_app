class CodesController < ApplicationController
  def new
    require 'net/http'
    require 'uri'
    require 'json'

    url = 'https://api.github.com/gists/public?page=' + rand(10).to_s + '&per_page=100'
    res = Net::HTTP.get(URI.parse(url))
    array = JSON.parse(res)

    code = ''
    language = ''

    for item in array
        filename = item["files"].keys.first
        language = item["files"][filename]["language"]

        if is_programming_lang?(language) && language != nil
            raw_url = item["files"][filename]["raw_url"]
            code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')
            code = hide_answer_lang(language, code)
            Code.create(language: language, code: code)
        end
    end
  end

  private
  def is_programming_lang?(lang)
    nonpro_lang = ['SVG', 'YAML', 'HTML', 'XML', 'JSON', 'Git', 'Text', 'Markdown']
    for item in nonpro_lang
        if item == lang
            return false
        end
    end
    return true
  end

  def hide_answer_lang(lang, code)
    if lang.length != 1
      code = code.gsub(/#{lang}/i, '???')
    end
    return code
  end
end
