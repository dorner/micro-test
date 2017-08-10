class MerchantUser < User
  include UserPermissions::MerchantUserMixin
end
