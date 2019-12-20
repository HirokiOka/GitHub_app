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
    @accuracy_rate = calc_accuracy_rate(stock)
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
    jscode = choose_code()
    @code = jscode.code
    ast = js_to_ast(@code)
    
    @filename = jscode.filename.gsub(".js", "")
    @link = jscode.html_url

    if ast == nil
      messages = ["睡眠をとりましょう", "散歩に出かけてみましょう", "nullの予感", "気持ちを落ち着かせるためには、睡眠が必須","苦手な仕事や、面倒な作業こそ先に片付けてしまいましょう","たまには息抜きも必要"]
      @work_luck = "★★☆☆☆"
      @interpersonal_luck = "★★☆☆☆"
      @message = messages[rand(messages.length)]
    elsif ast == "SyntaxError"
      @work_luck = "★☆☆☆☆"
      @interpersonal_luck = "★☆☆☆☆"
      @message = "注意！SyntaxErrorの予感！"

    else

      comments_rate = ast.comments.to_s.length * 100 / jscode.code.length
      only_code_length = jscode.code.length - ast.comments.to_s.length
      
      cpf = count_function(ast) == 0 ? 0 : only_code_length / count_function(ast)
      @work_luck = calc_work_luck(cpf)
      @interpersonal_luck = calc_interpersonal_luck(comments_rate)
      @message = generate_message(get_func_name(ast))
    end
  end

  private

  def generate_message(func_name)
      template = [
        "#{func_name}するといいかも．",
        "#{func_name}なことが起こりそう．",
        "#{func_name}なところに出かけてみよう．",
        "#{func_name}に注意．",
        "たまには#{func_name}も必要．",
        "今日は気分を変えて#{func_name}してみては．",
        "経験したことのない#{func_name}に挑戦してみましょう．",
        "気持ちを落ち着かせるためには，#{func_name}が必要"
      ]
      return template[rand(template.length)]
  end


  def get_func_name(ast)
    func_names = []
    arys = ast.to_sexp
    arys.each do |ary|
      h = Hash[*ary]
      func_names.push(h[:func_decl]) if (h[:func_decl] != nil && h[:func_decl].length != 0)
    end
    func_name = func_names[rand(func_names.length)]
    if func_name == nil
      return "anonymous"
    else
      return func_name
    end
  end


  def choose_code()
    codes_length = JsCode.all.length
    codes_length.times do
      jscode = JsCode.find_by(id: rand(codes_length) + 1)
      if !jscode.filename.include?("untrusted")
        return jscode
      end
    end
    nil
  end

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
    ast = ""
    begin
      ast = parser.parse(code)
    rescue SyntaxError => e
      ast = "SyntaxError"
    end
    ast
  end

  def calc_comments(comments)
    sum = 0
    comments.each do |comment|
      comment = comment.to_s.gsub(" ", "").gsub("COMMENT:", "")
      sum += comment.length
    end
    sum
  end

  def calc_interpersonal_luck(rate)
    if rate < 20
      "★☆☆☆☆"
    elsif rate < 30
      "★★☆☆☆"
    elsif rate < 50
      "★★★☆☆"
    elsif rate < 60
      "★★★★☆"
    else
      "★★★★★"
    end
  end

  def calc_work_luck(cpf)
    if 0 < cpf && cpf < 200
      "★★★★★"
    elsif cpf < 300
      "★★★★☆"
    elsif cpf < 400
      "★★★☆☆"
    elsif cpf < 500
      "★★☆☆☆"
    else
      "★☆☆☆☆"
    end
  end

  def count_function(ast)
    if ast == nil
      0
    end
    count = 0
    ary = ast.to_sexp
    ary.each do |item|
      h = Hash[*item]
      count += h.count { |k, _| k.to_s.include?("func_decl") }
    end
    count
  end
end
