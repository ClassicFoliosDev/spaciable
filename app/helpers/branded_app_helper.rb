# frozen_string_literal: false

module BrandedAppHelper
  def self.create_destroy_actions(params, parent)
    branded_app = BrandedApp.find_by(app_owner: parent)
    if params[:personal_app].to_i.positive?
      create_branded_app(parent, branded_app)
    else
      delete_branded_app(parent, branded_app)
    end
  end

  def self.create_branded_app(parent, branded_app)
    return if branded_app

    BrandedApp.create(app_owner: parent)
  end

  def self.delete_branded_app(_parent, branded_app)
    return unless branded_app

    branded_app.destroy!
  end
end
