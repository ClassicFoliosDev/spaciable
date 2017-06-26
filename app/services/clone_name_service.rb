# frozen_string_literal: true
module CloneNameService
  module_function

  def call(old_name)
    last_char = old_name[old_name.length - 1]

    if last_char.to_i.positive?
      number = (last_char.to_i + 1)
      name = old_name[0, old_name.length - 1]
      name << number.to_s
    else
      name = old_name + " 1"
    end

    name
  end
end
