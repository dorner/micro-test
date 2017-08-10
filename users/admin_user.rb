class AdminUser < User
  include UserPermissions::AdminUserMixin

  def show_notifications?
    true
  end
end
