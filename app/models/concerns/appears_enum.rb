# frozen_string_literal: true

module AppearsEnum
  extend ActiveSupport::Concern

  included do
    enum appears: %i[
      always
      moved_in
      completed
      after_emd
      after_emd_date
    ]
  end
end
