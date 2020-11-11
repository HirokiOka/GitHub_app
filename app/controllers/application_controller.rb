class ApplicationController < ActionController::Base
    before_action :set_current_user
    protect_from_forgery with: :exception
    helper_method :current_user, :logged_in?

    response.headers['X-Frame-Options'] = 'ALLOWALL'

    def set_current_user
        @current_user = User.find_by(id: session[:user_id])
    end

    def authenticate_user
        if @current_user == nil
          flash[:notice] = "ログインが必要です"
          redirect_to("/login")
        end
      end

      def forbid_login_user
        if @current_user
            flash[:notice] = "すでにログインしています"
            redirect_to("/users/index")
        end
      end

      private

      def current_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
      end

      def logged_in?
        !!session[:user_id]
      end

      def authenticate
        return if logged_in?
        redirect_to root_path, alert: 'ログインしてください'
      end
end
