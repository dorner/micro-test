class SuUser < AdminUser
  include UserPermissions::SuUserMixin
end
