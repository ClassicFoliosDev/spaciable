# frozen_string_literal: true

class String
  # This is a heavily doctored version of the parameterize function
  # found here
  #
  # https://apidock.com/rails/ActiveSupport/Inflector/parameterize
  #
  # It includes the "&" as an allowable character
  def parameterize_amp
      parameterized_string = self.dup

      # Turn unwanted chars into the separator.
      parameterized_string.gsub!(/[^a-zA-Z0-9&\-_]+/, "-")

      re_duplicate_separator        = /-{2,}/
      re_leading_trailing_separator = /^-|-$/

      # No more than one of the separator in a row.
      parameterized_string.gsub!(re_duplicate_separator, "-")
      # Remove leading/trailing separator.
      parameterized_string.gsub!(re_leading_trailing_separator, "".freeze)

      parameterized_string.downcase!
      parameterized_string
  end
end
