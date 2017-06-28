# frozen_string_literal: false
module CloneNameService
  module_function

  def call(old_name)
    base_name, new_number = init(old_name)

    existing_unit_type = true
    while existing_unit_type
      new_number += 1
      name = base_name + new_number.to_s
      existing_unit_type = UnitType.find_by_name(name)
    end

    name
  end

  def init(old_name)
    last_index = old_name.length - 1
    last_char = old_name[last_index]

    if last_char =~ /[[:alpha:]]/
      base_name = old_name + " "
      new_number = 0
    else
      numbers_in_string = old_name.scan(/\d+/)
      old_number = numbers_in_string[numbers_in_string.length - 1]
      old_number_index = old_name.index(old_number.to_s)

      base_name = old_name[0, old_number_index]
      new_number = old_number.to_i
    end

    [base_name, new_number]
  end
end
