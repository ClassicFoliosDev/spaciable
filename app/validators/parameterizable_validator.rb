# frozen_string_literal: true
class ParameterizableValidator < ActiveModel::Validator
  def validate(record)
    name = find_name(record)

    # There are other validators for nil / empty values
    return unless name

    compare_with = name.downcase.split(" ").join("-")
    if name.parameterize == compare_with
      # The test above should find all invalid characters except a dash,
      # so check dash explicitly
      index_dash = name.index("-")
      return if index_dash.nil?
    end

    record.errors.add(:base, :invalid_name, value: name)
  end

  private

  def find_name(record)
    case record
    when Developer
      record.company_name
    when Division
      record.division_name
    when Development
      record.name
    end
  end
end
