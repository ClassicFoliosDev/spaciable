class UpdateAnalyticsTitles < ActiveRecord::Migration[5.0]
  def change

    # "Main Menu" -> "Dashboard"
    Ahoy::Event.where(name: "Main Menu").update_all(name: "Dashboard")

    # "Your Journey"/"Splash" -> "Welcome Page"
    Ahoy::Event.where(name: 'Your Journey').where("properties @> \'{\"category1\": \"Splash\"}\'")
               .update_all("properties = jsonb_set(properties, \'{category1}\', to_json(\'Welcome Page\'::text)::jsonb)")

    # "positive"-> "Positive"
    Ahoy::Event.where("properties @> \'{\"category2\": \"positive\"}\'")
               .update_all("properties = jsonb_set(properties, \'{category2}\', to_json(\'Positive\'::text)::jsonb)")

    # "negative"-> "Negative"
    Ahoy::Event.where("properties @> \'{\"category2\": \"negative\"}\'")
               .update_all("properties = jsonb_set(properties, \'{category2}\', to_json(\'Negative\'::text)::jsonb)")

    # "Refer a Friend" -> "Referrals Submitted"
    Ahoy::Event.where(name: 'Refer a Friend')
               .update_all(name: 'Referrals Submitted')

    # Contact categories
    Contact.categories.each do |cat, _|

      category = I18n.t("activerecord.attributes.contact.categories.#{cat}")
      # update cat (i.e. 'sales') to (typically uppercase) translation i.e. 'Sales'
      Ahoy::Event.where(name: I18n.t('layouts.homeowner.nav.contacts'))
                 .where("properties @> \'{\"category1\": \"#{cat}\"}\'")
                 .update_all("properties = jsonb_set(properties, \'{category1}\', to_json(\'#{category}\'::text)::jsonb)")
    end

    # How-To categories
    HowTo.categories.each do |cat, _|
      next if cat.start_with?('ukp')

      category = I18n.t("activerecord.attributes.how_to.categories.#{cat}")
      # update cat (i.e. 'home') to (typically uppercase) translation i.e. 'Home'
      Ahoy::Event.where(name: I18n.t('activerecord.models.how_to'))
                 .where("properties @> \'{\"category1\": \"#{cat}\"}\'")
                 .update_all("properties = jsonb_set(properties, \'{category1}\', to_json(\'#{category}\'::text)::jsonb)")
      # update 'Main' to "[category] Menu"
      Ahoy::Event.where(name: I18n.t('activerecord.models.how_to'))
                 .where("properties @> \'{\"category1\": \"#{category}\"}\'")
                 .where("properties @> \'{\"category2\": \"Main\"}\'")
                 .update_all("properties = jsonb_set(properties, \'{category2}\', to_json(\'#{category} Menu\'::text)::jsonb)")
    end

    # Sign_in

    # "Log In" -> "Returning User"
    Ahoy::Event.where(name: I18n.t('ahoy.homeowner_sign_in'))
               .where("properties @> \'{\"category1\": \"Log in\"}\'")
               .update_all("properties = jsonb_set(properties, \'{category1}\', to_json(\'#{I18n.t('ahoy.homeowner_log_in')}\'::text)::jsonb)")

    # "Log In" -> "Returning User"
    Ahoy::Event.where(name: I18n.t('ahoy.homeowner_sign_in'))
               .where("properties @> \'{\"category1\": \"Accept Invitation\"}\'")
               .update_all("properties = jsonb_set(properties, \'{category1}\', to_json(\'#{I18n.t('ahoy.homeowner_accept_invite')}\'::text)::jsonb)")
  end
end
