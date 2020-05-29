Development.all.each do |dev|
  parent_developer =  dev.developer || dev.division.developer

  [["referrals", 2], ["services", 3], ["perks", 4]].each do |tag, value|
    if parent_developer.send("enable_#{tag}")
      CustomTile.create(feature: value, development_id: dev.id)
    end
  end
end

