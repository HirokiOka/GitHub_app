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

        if is_programming_lang?(@@lang) && @@lang != nil
          @langClass = "language-" + @@lang.downcase
          raw_url = element["files"][filename]["raw_url"]
          @code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')
          # @code = hide_answer_lang(@@lang, @code)

          break
        end
      end
    end

  def judge
    if params[:answer] == @@lang
      flash[:notice] = "正解です！"
      if @current_user
        flash[:notice] = "正解です！+10pt!"
        @user = User.find_by(id: @current_user.id)
        @user.score += 10
        @user.save
      end
    else
      flash[:notice] = "正解は#{@@lang}でした！"
    end
    redirect_to("/quiz")
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
