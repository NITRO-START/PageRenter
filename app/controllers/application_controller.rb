class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    user_params = params['user']
    if user_params.is_a?(String) && user_params.length >= 2
      user_params = JSON.parse(user_params)

      if user_params.is_a?Hash then if (user_params.has_key?('locale') && (user_params['locale'].length >= 2)) then session[:user_idiom] = user_params['locale'] end end
    end

    # Idiom setted by the session just if necessary to find the user on BD, if the locale cames with the browser, it is scaped
    if !session[:user_id].nil? & session[:user_idiom].nil? then session[:user_idiom] = User.find(session[:user_id]).locale[0..1] end
    I18n.locale = session[:user_idiom] || I18n.default_locale
  end

  def setup_user
    if @current_user.nil? then @current_user = User.find(session['user_id']) end
  end

  def self.land_url
    # 'http://pagerenter.com.br'
    'http://localhost/LandPageRenter/LandPageRenter/'
  end
end
