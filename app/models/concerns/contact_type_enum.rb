# frozen_string_literal: true

module ContactTypeEnum
  extend ActiveSupport::Concern

  included do
    enum contact_type:
    {
      # leave 0 for 'blank/unassigned'
      available_IFA: 1,
      available_Solicitor: 2,
      local_authority: 3,
      sales_team: 4,
      utility_supplier: 5
    }
  end
end
