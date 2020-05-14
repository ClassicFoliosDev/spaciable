# Timelines can be global, or associated with developers. In order
# for generic form handling to be possible, each timeline
# needs to identify a parent.  This single global record acts
# as the parent to all 'global' Timelines
Global.create(name: "CFAdmin") if Global.count == 0

# Add the timeline stages
if Stage.count == 0
  Stage.create(title: 'Reservation')
  Stage.create(title: 'Exchange')
  Stage.create(title: 'Moving')
  Stage.create(title: 'Living')
end

# Add the shortcuts
if Shortcut.count == 0
  Shortcut.create(shortcut_type: :how_tos, link: "homeowner_how_tos_path")
  Shortcut.create(shortcut_type: :faqs, link: "homeowner_faqs_path")
  Shortcut.create(shortcut_type: :services, link: "services_path")
  Shortcut.create(shortcut_type: :area_guide, link: "https://www.bestarea4me.com/demo/")
end
