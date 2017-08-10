require 'user'

class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :ensure_logged_in
  helper_method :logged_in?, :current_user

  # @return [User]
  def current_user
    @current_user
  end

  def ensure_logged_in
    get_current_user
    return if Rails.env.test? || @current_user
    session[:path_to_go_to_after_login] = request.fullpath
    redirect_to '/login'
  end

  # @return [Boolean]
  def logged_in?
    !!current_user
  end

  # @return [User]
  def get_current_user
    @current_user = if Rails.env.development? &&
        File.exists?("#{Rails.root}/config/user.yml")
      user_hash = YAML.load_file("#{Rails.root}/config/user.yml")
      if user_hash && user_hash['user']
        extra_attributes = user_hash.delete('extra_attributes')
        user = User.find_by_login(user_hash['user']['login'])
        if user.nil?
          klass = user_hash['user']['type'].constantize
          user = klass.create!(user_hash['user'])
        end
        if user
          user.extra_attributes = extra_attributes || {}
          user
        end
      end
    end
    return @current_user if @current_user

    extra_attributes = request.session[:cas_extra_attributes]
    return unless extra_attributes
    user_info = extra_attributes['user_info']
    klass = user_info['type'].constantize
    @current_user = User.where(:email => user_info['email']).first ||
        klass.create!(
            vendor_id: user_info['vendor_id'],
            email:     user_info['email'],
            name:      user_info['name'],
            uid:       user_info['uid'],
            login:     user_info['login']
        )
    @current_user.extra_attributes = extra_attributes
  end

end
