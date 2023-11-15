# frozen_string_literal: true

module Unlatch
  class Unauthorised < StandardError
    def initialize(msg = "UPLATCH: Unauthorised")
      super(msg)
    end
  end
end
