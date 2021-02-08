# Timelines can be global, or associated with developers. In order
# for generic form handling to be possible, each timeline
# needs to identify a parent.  This single global record acts
# as the parent to all 'global' Timelines
Global.create(name: "CFAdmin") if Global.count == 0

# Add the timeline stages
if Stage.count == 0
  journey = StageSet.create(stage_set_type: :journey)
  %w[Reservation Exchange Moving Living].each_with_index do |title, index|
    Stage.create(title: title, order: index+1, stage_set_id: journey.id)
  end

  proforma = StageSet.create(stage_set_type: :proforma)
  %w[Reservation Exchange Moving Living].each_with_index do |title, index|
    Stage.create(title: title, order: index+1, stage_set_id: proforma.id)
  end
end

# Add the shortcuts
if Shortcut.count == 0
  Shortcut.create(shortcut_type: :how_tos, link: "homeowner_how_tos_path")
  Shortcut.create(shortcut_type: :faqs, link: "homeowner_faqs_path")
  Shortcut.create(shortcut_type: :services, link: "services_path")
  Shortcut.create(shortcut_type: :area_guide, link: "https://www.bestarea4me.com/demo/")
end
