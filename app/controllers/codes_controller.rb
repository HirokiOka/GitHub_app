class CodesController < ApplicationController
  def new
    require 'net/http'
    require 'uri'
    require 'json'

    gist_url = 'https://api.github.com/gists/public?page=' + rand(10).to_s + '&per_page=100'
    res = Net::HTTP.get(URI.parse(gist_url))
    array = JSON.parse(res)

    code = ''
    language = ''

    for item in array
        filename = item["files"].keys.first
        language = item["files"][filename]["language"]

        if is_programming_lang?(language) && language != nil
            raw_url = item["files"][filename]["raw_url"]
            code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')
            html_url = item["html_url"]
            Code.create(language: language, code: code, html_url: html_url)
        end
    end
  end

  private
  def is_programming_lang?(lang)
    nonpro_lang = ['SVG', 'YAML', 'HTML', 'XML', 'JSON', 'Git', 'Text', 'Markdown', 'Jupyter Notebook', 'Shell']
    for item in nonpro_lang
        if item == lang
            return false
        end
    end
    return true
  end
end
