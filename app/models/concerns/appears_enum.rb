# frozen_string_literal: true

module AppearsEnum
  extend ActiveSupport::Concern

  included do
    enum appears: %i[
      always
      moved_in
      completed
      after_emd
      emd_on_after
      emd_on_before
      emd_between
    ]
  end
end
