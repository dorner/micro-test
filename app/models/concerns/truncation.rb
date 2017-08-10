require 'active_support/concern'

module Concerns::Truncation
  extend ActiveSupport::Concern

  included do
    class_attribute :_fields_to_truncate
    before_save :_truncate_fields
  end

  class_methods do
    def truncates(*fields)
      self._fields_to_truncate = fields
    end
  end

  def _truncate_fields
    self._fields_to_truncate.each do |field|
      col = self.class.columns.find { |c| c.name == field.to_s }
      max_length = col.limit
      val = self[field]
      if val.present? && val.size > max_length
        self[field] = val[0...max_length-3] + '...'
      end
    end
  end

end
