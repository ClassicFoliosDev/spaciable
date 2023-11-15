# frozen_string_literal: true

module Unlatch
  class Log < ApplicationRecord
    self.table_name = "unlatch_logs"
    belongs_to :linkable, polymorphic: true

    class << self
      def add(linkable, error)
        Unlatch::Log.create(linkable: linkable, error: error)
        Rails.logger.error(error)
      end
    end

  end
end
