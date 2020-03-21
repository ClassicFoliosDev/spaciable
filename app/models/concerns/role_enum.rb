# frozen_string_literal: true

module RoleEnum
  extend ActiveSupport::Concern

  included do
    enum role: [
      :cf_admin, # Classic Folio Admin
      :developer_admin,
      :division_admin,
      :development_admin,
      :site_admin
    ]
  end
end
