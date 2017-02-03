# frozen_string_literal: true
class HexValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    # 3 or 6 digit hex code with optional # at front
    return if value =~ /^#?(?:[0-9a-fA-F]{3}){1,2}$/
    record.errors.add(attribute, :not_valid_hex)
  end
end
