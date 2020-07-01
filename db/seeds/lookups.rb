
# If more lookups need to be added, add them to the table and
# add
#
# load Rails.root.join("db/seeds", "lookups.rb")
#
# to the migration script.  This needs to maintain
# backward compatibility so NEVER DELETE A CODE
#

Lookup.destroy_all
[
  ["developer", "*:developer.company_name"],
  ["divison", "*:division.division_name"],
  ["phase", "*:phase.name"],
  ["development", "*:development.name"],
  ["plot", "Plot:number"],
  ["move_in_date", "Plot:completion_date"],
  ["expiry_date", "Plot:expiry_date"],
  ["progress", "Plot:progress", "activerecord.attributes.plot.progresses"],
  ["postal", "Plot:address.postal_number"],
  ["building", "Plot:address.building_name"],
  ["road", "Plot:address.road_name"],
  ["postcode", "Plot:address.postcode"],
  ["locality", "Plot:address.locality"],
  ["locality", "Plot:address.locality"],
  ["city", "Plot:address.city"],
  ["county", "Plot:address.county"],
  ["first_name", "Resident:first_name"],
  ["last_name", "Resident:last_name"],
  ["email", "Resident:email"],
  ["phone", "Resident:phone_number"]
].each do |code, column, translation|
  Lookup.create(code: code,
                column: column,
                translation: translation)
end

