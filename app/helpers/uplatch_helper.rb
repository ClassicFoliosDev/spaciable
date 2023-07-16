# frozen_string_literal: true

module UplatchHelper
  # Get the Countries
  def uplatch_developers
    Unlatch::Developer.list
  end

  def uplatch_programs(developer)
    Unlatch::Program.list(developer)
  end
end
