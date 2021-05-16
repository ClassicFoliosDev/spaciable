# frozen_string_literal: true

# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module CallbackFixture
  module_function

  RETRIES = 4

  def confirm(&block)
    (1..RETRIES).each do |_|
      break if block.call
      sleep 1
    end
  end
end
# rubocop:enable ModuleLength
