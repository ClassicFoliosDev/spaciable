# frozen_string_literal: true
module TitleEnum
  extend ActiveSupport::Concern

  included do
    enum title: [
      :mr,
      :ms,
      :mrs,
      :miss,
      :dr,
      :prof,
      :other
    ]
  end
end
