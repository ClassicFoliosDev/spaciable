# frozen_string_literal: true

module TitleEnum
  extend ActiveSupport::Concern

  included do
    enum title: %i[
      mr
      ms
      mrs
      miss
      dr
      prof
      other
    ]
  end
end
