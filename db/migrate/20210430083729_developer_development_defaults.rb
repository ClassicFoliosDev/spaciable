class DeveloperDevelopmentDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default :developers, :house_search, from: false, to: true
    change_column_default :developers, :enable_referrals, from: false, to: true
    change_column_default :developers, :enable_services, from: false, to: true
    change_column_default :developers, :enable_perks, from: false, to: true
    change_column_default :developments, :enable_snagging, from: false, to: true
    change_column_default :developments, :snag_duration, from: 0, to: 14
  end
end
