class HomeController < ApplicationController
  before_action :forbid_login_user, {only: [:top]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}

  @@lang = ''

  def top
  end

  def about
  end

  def quiz
    require 'net/http'
    require 'uri'
    require 'json'

    url = 'https://api.github.com/gists/public?page=' + rand(10).to_s + '&per_page=1'
    res = Net::HTTP.get(URI.parse(url))
    array = JSON.parse(res)

    lang = ""
    code = ""

    for element in array
        filename = element["files"].keys.first
        @@lang = element["files"][filename]["language"]
        if lang != nil
            @langClass = "language-" + @@lang.downcase
            raw_url = element["files"][filename]["raw_url"]
            @code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')

            break
        end
    end
  end

  def judge
    if params[:answer] == @@lang
      flash[:notice] = "正解です！"
      #ログインしていたらscoreをプラスする処理
    else
      flash[:notice] = "正解は#{@@lang}でした！"
    end
    redirect_to("/quiz")
  end

end
