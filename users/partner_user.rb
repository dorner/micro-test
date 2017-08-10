class PartnerUser < AdminUser
  include UserPermissions::PartnerUserMixin
end
