# frozen_string_literal: true
module CloneNameService
  module_function

  def call(old_name)
    last_index = old_name.length - 1
    last_char = old_name[last_index]

    return old_name + " 1" if last_char =~ /[[:alpha:]]/

    numbers_in_string = old_name.scan(/\d+/)
    old_number = numbers_in_string[numbers_in_string.length - 1]
    old_number_index = old_name.index(old_number.to_s)

    new_number = (old_number.to_i + 1)
    name = old_name[0, old_number_index]
    name << new_number.to_s

    name
  end
end
