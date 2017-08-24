# frozen_string_literal: true
module SeedsFixture
  module_function

  def baumatic_link
    "https://olr.domesticandgeneral.com/app/pages/ApplicationPage.aspx?country=gb&lang=en&brand=BAUM"
  end

  def caple_link
    "http://www.caple.co.uk/special/guarantee/"
  end

  def create_appliance_manufacturers
    FactoryGirl.create(:appliance_manufacturer, name: "Aeg")
    FactoryGirl.create(:appliance_manufacturer, name: "Beko")
    FactoryGirl.create(:appliance_manufacturer, name: "BauMatic", link: baumatic_link)
    FactoryGirl.create(:appliance_manufacturer, name: "Caple", link: caple_link)
  end
end
