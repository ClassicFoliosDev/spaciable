# frozen_string_literal: true

module Unlatch
  class Log < ApplicationRecord
    self.table_name = "unlatch_logs"
     belongs_to :linkable, polymorphic: true
  end
end
