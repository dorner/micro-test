class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # @param enum_key [Symbol]
  # @return [Array<String, Integer>] a titleized hash usable with select tags.
  def self.titleized_enum(enum_key)
    enums = self.send(enum_key.to_s.pluralize)
    Hash[enums.map { |k, v| [k.titleize, k] }]
  end

  # @return [String]
  def simple_display
    self.to_json
  end

  # Recursively maps instances to GlobalID URIs if necessary. Leaves other data
  # types untouched.
  # @param obj [Object] The object to perform serialization on
  def self.globalize_instances(obj)
    case obj
      when GlobalID::Identification
        ActiveJob::Arguments.send(:serialize_argument, obj)
      when Array
        obj.map { |v| globalize_instances(v) }
      when Hash
        obj.each do |k, v|
          obj[k] = globalize_instances(v)
        end
      else
        obj
    end
  end

  # Recursively maps GlobalID URIs to instances if necessary. Leaves other data
  # types untouched.
  # @param obj [Object] The object to perform deserialization on
  def self.deglobalize_instances(obj)
    case obj
      when Array
        obj.map { |v| deglobalize_instances(v) }
      when Hash
        if ActiveJob::Arguments.send(:serialized_global_id?, obj)
          return ActiveJob::Arguments.send(:deserialize_argument, obj)
        end
        obj.each do |k, v|
          obj[k] = deglobalize_instances(v)
        end
      else
        obj
    end
  end

end
