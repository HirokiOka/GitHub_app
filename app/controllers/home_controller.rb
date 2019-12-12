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
    session[:lang] = stock.language
    session[:code_id] = stock.id
    @lang_class = 'language-' + stock.language.downcase
    @code = hide_answer_lang(stock.language, stock.code)
    @accuracy_rate =  calc_accuracy_rate(stock)
  end


  def judge
    if @current_user
      Answer.create(code_id: session[:code_id], user_id: @current_user.id, answer: params[:answer].downcase)
      if check_the_answer(params[:answer], session[:lang])
        flash[:notice] = "正解です！+10pt!"
        @user = User.find_by(id: @current_user.id)
        @user.score += 10
        @user.save
      else
        flash[:notice] = "正解は#{session[:lang]}でした！"
      end
    else
      if check_the_answer(params[:answer], session[:lang])
        flash[:notice] = "正解です！"
      else
        flash[:notice] = "正解は#{session[:lang]}でした！"
      end
    end
    session[:lang] = nil
    session[:code_id] = nil
    redirect_to("/quiz")
  end

  # def fortune_telling
  #   stock_length = Code.all.length
  #   stock = Code.find_by(id: rand(stock_length)+1)
  #   @@lang = stock.language
  #   @lang_class = 'language-' + @@lang.downcase
  #   @code = stock.code
  #   @html_url = stock.html_url
  # end

  def fortune_telling
    stock_length = JsCode.all.length
    jscode = JsCode.find_by(id: rand(stock_length)+1)
    @filename = jscode.filename
    @code = jscode.code
    @link = jscode.html_url
  end

  private
  def hide_answer_lang(lang, code)
    (lang.length != 1) ? code.gsub(/#{lang}/i, '???') : code
  end

  def check_the_answer(answer, correct_answer)
    answer.downcase == correct_answer.downcase
  end

  def calc_accuracy_rate(code)
    answers = code.answers
    correct_answer_num = 0
    answers.each do |answer|
      if check_the_answer(answer.answer, code.language)
        correct_answer_num += 1
      end
    end
    answers.length == 0 ? 0 : (correct_answer_num / answers.length) * 100
  end
end
