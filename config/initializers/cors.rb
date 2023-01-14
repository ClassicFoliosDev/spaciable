# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("CORS_ORIGIN","").split(",")
    resource '/oauth/token', headers: :any, methods: [:post]
    resource '/api/admin/single_page_app_pre_sales', headers: :any, methods: [:post]
  end
end