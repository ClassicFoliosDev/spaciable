# frozen_string_literal: true

module BrandFixture
  module_function

  def bg_color
    "44C671"
  end

  def button_text_color
    "#556a41"
  end

  def header_color
    "890033"
  end

  def topnav_text_color
    "#48f442"
  end

  def android_link
    "https://en.wikipedia.org/wiki/Goat"
  end

  def apple_link
    "https://en.wikipedia.org/wiki/Domestic_pigeon"
  end

  def app_icon
    "services.jpg"
  end

  def default_android_link
    "https://play.google.com/store/apps/details?id=io.gonative.android.kodlkr&hl=en_GB"
  end

  def default_apple_link
    "https://apps.apple.com/app/apple-store/id1454008219?pt=119736329&ct=download%20reminder&mt=8"
  end

  def default_app_icon
    "Spaciable_icon.png"
  end

  def update_app_icon
    filename = FileFixture.appliance_secondary_picture_name
    path = Rails.root.join("features", "support", "files", filename)

    File.open(path) do |file|
      BrandFixture.branded_app.update_attribute(:app_icon, file)
    end
  end

  def branded_app
    developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
    BrandedApp.find_by(app_owner_id: developer.id)
  end
end
