class SessionsController < ApplicationController
  skip_before_filter :ensure_logged_in

  def login
    if CASClient::Frameworks::Rails::Filter.filter(self)
      path_user_was_on = session.delete(:path_to_go_to_after_login) || root_path
      redirect_to path_user_was_on
    end
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self, request.referer || root_url)
  end
end
