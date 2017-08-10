class User < ApplicationRecord
  include UserPermissionsMixin

  def show_notifications?
    false
  end
end

