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
      utility_supplier: 5,
      managing_agent: 6,
      warranty_provider: 7,
      concierge: 8,
      cust_care: 9
    }
  end
end
