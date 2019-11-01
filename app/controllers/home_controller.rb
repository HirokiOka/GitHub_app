class HomeController < ApplicationController
  before_action :forbid_login_user, {only: [:top]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}

  @@lang = ''

  def top
  end

  def about
  end

  def quiz
    stock_length = Code.all.length
    stock = Code.find_by(id: rand(stock_length)+1)
    @@lang = stock.language
    @lang_class = 'language-' + @@lang.downcase
    @code = hide_answer_lang(@@lang, stock.code)
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

  def fortune_telling
    stock_length = Code.all.length
    stock = Code.find_by(id: rand(stock_length)+1)
    @@lang = stock.language
    @lang_class = 'language-' + @@lang.downcase
    @code = stock.code
    @html_url = stock.html_url
  end

  private
  def hide_answer_lang(lang, code)
    if lang.length != 1
      code = code.gsub(/#{lang}/i, '???')
    end
    return code
  end
end
