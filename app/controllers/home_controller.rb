require 'rkelly'

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

  def fortune_telling
    stock_length = JsCode.all.length
    jscode = JsCode.find_by(id: rand(stock_length)+1)
    @filename = jscode.filename.gsub(".js", "")
    @code = jscode.code
    @link = jscode.html_url
    ast = js_to_ast(@code)
    @work_luck = calc_work_luck(count_function(ast))
    @interpersonal_luck = calc_interpersonal_luck(calc_comments(ast.comments))
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

  def js_to_ast(code)
    parser = RKelly::Parser.new
    parser.parse(code)
  end

  def calc_comments(comments)
    sum = 0
    comments.each do |comment|
      comment = comment.to_s.gsub(" ", "").gsub("COMMENT:", "")
      sum += comment.length
    end
    sum
  end

  def calc_interpersonal_luck(count)
    if count < 100
      "★☆☆☆☆"
    elsif count < 200
      "★★☆☆☆"
    elsif count < 300
      "★★★☆☆"
    elsif count < 400
      "★★★★☆"
    else
      "★★★★★"
    end
  end

  def calc_work_luck(count)
    if count < 1
      "★☆☆☆☆"
    elsif count < 2
      "★★☆☆☆"
    elsif count < 3
      "★★★☆☆"
    elsif count < 4
      "★★★★☆"
    else
      "★★★★★"
    end
  end

  def count_function(ast)
    count = 0
    ary = ast.to_sexp
    ary.each do |item|
      h = Hash[*item]
      count += h.count { |k, _| k.to_s.include?("func_decl") }
    end
    count
  end
end
