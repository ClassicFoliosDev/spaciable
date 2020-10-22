# frozen_string_literal: true

namespace :saleforce do
  desc "Load Saleforce connection config data - assume Developer 'Marvelous Homes'"
  task initialise: :environment do
    init_salesforce
  end

  def init_salesforce
    developer = Developer.find_by(company_name: "Marvelous Homes")
    return unless developer
    return if Crm.find_by(developer_id: developer.id)

    crm = Crm.create(developer_id: developer.id,
                     name: "Salesforce",
                     client_id: "3MVG9sh10GGnD4Dvqcvgd9n5OBu4al1MBNXYDHYcmAOO_OhKuIIcr2nSq2PoMAOfMoEKo3mqy2PCzeGKm2.Ov",
                     client_secret: "E95F6C50E7CE35452582184F0D0B3FFCC992EAA5640F9BA69E6DB0A3C75FC1BB",
                     redirect_uri: "https://spaciable.ngrok.io/salesforce/callback",
                     api_base_url: "https://classicfolios2020.lightning.force.com")

    token = AccessToken.new(crm: crm,
                            access_token: "00D4K000003r09s!AQIAQIH5hnO0XOtEE.b9lXJk6zUNWUQy.l3YtYWsM0r5nCTuJNz74ro41Ka5hz5_.8bedzetJkptqEMipLv9WQWM92RdqzPb",
                            refresh_token: "5Aep861wfm9ssIBS_.yQXnlUNloDxsKjNfGKV3KGyUkyvcL9BwmWSWuTaAP2tm0zsu_6wpcKpt2pKSaHZ5YOoJ_")
    token.save!
  end
end
