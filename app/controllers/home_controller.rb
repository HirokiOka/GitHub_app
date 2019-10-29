class HomeController < ApplicationController
  before_action :forbid_login_user, {only: [:top]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}

  def top
  end

  def about
  end

  def quiz
  end

  def judge
    if params[:answer] == 'JavaScript'
      flash[:notice] = "正解です"
    else
      flash[:notice] = "チガウヨ"
    end
    redirect_to("/quiz")
  end
end
