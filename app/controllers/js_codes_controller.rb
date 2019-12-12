class JsCodesController < ApplicationController
  def new
    require 'net/http'
    require 'uri'
    require 'json'

    gist_url = 'https://api.github.com/gists/public?page=' + rand(10).to_s + '&per_page=100'
    res = Net::HTTP.get(URI.parse(gist_url))
    array = JSON.parse(res)

    language = ''

    for item in array
      filename = item["files"].keys.first
      language = item["files"][filename]["language"]
      if language == "JavaScript"
        raw_url = item["files"][filename]["raw_url"]
        code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')
        html_url = item["html_url"]
        JsCode.create(filename: filename, code: code, html_url: html_url)
      end
    end
  end

end
