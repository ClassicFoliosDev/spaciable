# frozen_string_literal: true

module EpcRatingEnum
  extend ActiveSupport::Concern

  included do
    enum epc_rating:
    %i[
      no_rating
      epc_a
      epc_b
      epc_c
      epc_d
      epc_e
      epc_f
      epc_g
    ]
  end
end
