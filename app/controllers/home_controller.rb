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
    hash = JSON.parse(res)[0]
    key_name = hash["files"].keys.first
    raw_url = hash["files"][key_name]["raw_url"]

    @@lang = hash["files"][key_name]["language"]
    @code = Net::HTTP.get(URI.parse(raw_url))
  end

  def judge
    if params[:answer] == @@lang
      flash[:notice] = "正解です！"
    else
      flash[:notice] = "正解は#{@@lang}でした！"
    end
    redirect_to("/quiz")
  end

end
