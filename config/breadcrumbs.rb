crumb :root do
  link "Dashboard", root_path
end

crumb :help do
  link "Help", admin_help_path
end

# Admin Users
crumb :admin_users do
  link t("breadcrumbs.admin_users"), admin_users_path
end

crumb :admin_user_new do
  link t("breadcrumbs.admin_users_add"), new_admin_user_path
  parent :admin_users
end

crumb :admin_user_edit do |user|
  link t("breadcrumbs.admin_user_edit", user: user), edit_admin_user_path(user)
  parent :admin_users
end

crumb :admin_user do |user|
  link user.to_s, admin_user_path(user)
  parent :admin_users
end

# Admin Residents
crumb :admin_residents do
  link t("breadcrumbs.admin_residents"), admin_residents_path
end

crumb :admin_resident do |resident|
  link resident.to_s, admin_resident_path(resident)
  parent :admin_residents
end

# Admin Notifications - Notifications sent by Admins to Residents
crumb :admin_notifications do
  link t("breadcrumbs.admin_notifications"), admin_notifications_path
end

crumb :admin_notification_new do
  link t("breadcrumbs.admin_notifications_new"), new_admin_notification_path
  parent :admin_notifications
end

crumb :admin_notification do |notification|
  link notification.to_s, admin_notification_path(notification)
  parent :admin_notifications
end

# Admin Notifications - Notifications sent by CF Admins to other Admins
crumb :admin_admin_notifications do
  link t("breadcrumbs.admin_admin_notifications"), admin_admin_notifications_path
end

crumb :admin_admin_notifications_new do
  link t("breadcrumbs.admin_admin_notifications_new"), new_admin_admin_notification_path
  parent :admin_admin_notifications
end

crumb :admin_admin_notification do |admin_notification|
  link admin_notification.to_s, admin_admin_notification_path(admin_notification)
  parent :admin_admin_notifications
end

# Admin HowTos
crumb :admin_how_tos do
  link t("breadcrumbs.admin_how_tos"), admin_how_tos_path
end

crumb :admin_how_to_new do
  link t("breadcrumbs.admin_how_to_new"), new_admin_how_to_path
  parent :admin_how_tos
end

crumb :admin_how_to_edit do |how_to|
  link t("breadcrumbs.admin_how_to_edit", how_to: how_to), edit_admin_how_to_path
  parent :admin_how_tos
end

crumb :admin_how_to do |how_to|
  link how_to.to_s, admin_how_to_path(how_to)
  parent :admin_how_tos
end

# Admin Snags
crumb :admin_snag_overview do
  link t("breadcrumbs.admin_snag_overview"), admin_snags_phases_path
end

crumb :admin_plot_snags do |phase|
  link t("breadcrumbs.admin_plot_snags"), admin_snags_phase_path
  parent :admin_snag_overview
end

# Admin global settings
crumb :admin_settings do
  link t("breadcrumbs.admin_settings"), admin_settings_path
end

crumb :admin_settings_edit do
  link t("breadcrumbs.admin_settings_edit"), edit_admin_settings_path
  parent :admin_settings
end

# Analytics
crumb :reports do
  link t("breadcrumbs.admin_reports"), new_admin_analytics_path
end

# Current parent snag overview - cannot find phase id to pass to phases
crumb :admin_plot_snag do
  link t("breadcrumbs.admin_plot_snag"), admin_snags_plot_path
  parent :admin_snag_overview
end

# Current parent snag overview - cannot find plot id to pass to plots
crumb :admin_snag do |snag|
  link t("breadcrumbs.admin_snag", plot: snag.plot, phase: snag.phase, development: snag.development)
  parent :admin_snag_overview
end

crumb :default_faqs do |type|
  link t("breadcrumbs.default_faqs", country: type.country.name, type: type.name), (admin_settings_default_faqs_path ({active_tab: type.id}))
  parent :admin_settings
end

crumb :default_faq do |default_faq|
  link default_faq.question.html_safe
  parent :default_faqs, default_faq.faq_type
end

crumb :default_faq_edit do |default_faq, faq_type|
  link t("breadcrumbs.default_faqs_edit", default_faq: default_faq)
  parent :default_faqs, faq_type
end

crumb :default_faq_add do |faq_type|
  link t("breadcrumbs.default_faqs_add")
  parent :default_faqs, faq_type
end

# DEVELOPERS

crumb :developers do
  link Developer.model_name.human.pluralize, developers_path
end

crumb :developer_edit do |developer|
  link t("breadcrumbs.developer_edit", developer_name: developer.company_name), developers_path(developer)
  parent :developers
end

crumb :developer_new do
  link t("breadcrumbs.developer_add")
  parent :developers
end

crumb :developer do |developer|
  link developer.company_name, developer_path(developer)
  parent :developers
end

# DIVISIONS

crumb :developer_divisions do |developer|
  link Division.model_name.human.pluralize, [developer, active_tab: :divisions]
  parent :developer, developer
end

crumb :division do |division|
  title = division.division_name

  link title, developer_division_path(division.developer, division)
  parent :developer, division.developer
end

crumb :division_edit do |division|
  title = t("breadcrumbs.division_edit", division_name: division.division_name)

  link title, edit_developer_division_path(division.developer, division)
  parent :developer, division.developer
end

crumb :division_new do |developer|
  link t("breadcrumbs.division_add")
  parent :developer, developer
end

# DEVELOPMENTS

crumb :sync_development_docs do |development|
  link t("breadcrumbs.sync_docs")
  parent :development, development
end

crumb :development_edit do |development|
  title = t("breadcrumbs.development_edit", development_name: development.name)

  parent :developments, development.parent

  if development.parent.is_a?(Developer)
    link title, edit_developer_development_path(development.parent, development)
  elsif development.parent.is_a?(Division)
    link title, edit_division_development_path(development.parent, development)
  end
end

crumb :development do |development|
  title = development.name

  if development.parent.is_a?(Developer)
    link title, developer_development_path(development.parent, development)
    parent :developer, development.parent
  elsif development.parent.is_a?(Division)
    link title, division_development_path(development.parent, development)
    parent :division, development.parent
  end
end

crumb :developments do |developments_parent|
  case developments_parent
  when Developer
    link Development.model_name.human.pluralize, developer_developments_path(developments_parent)
    parent :developer, developments_parent
  when Division
    link Development.model_name.human.pluralize, division_developments_path(developments_parent)
    parent :division, developments_parent
  end
end

crumb :development_new do |development_parent|
  link t("breadcrumbs.development_new")
  parent :developments, development_parent
end

crumb :development_csv do |development|
  link t("breadcrumbs.development_csv")
  parent :development, development
end

# DIVISION DEVELOPMENTS

crumb :division_developments do |division|
  link Development.model_name.human.pluralize, division_developments_path(division)
  parent :division, division
end

# DEVELOPMENT PHASES

crumb :phases do |development|
  link Phase.model_name.human.pluralize, development_phases_path(development)
  parent :development, development
end

crumb :phase_edit do |phase|
  link t("breadcrumbs.phase_edit", phase_name: phase.name), edit_development_phase_path(phase.development, phase)
  parent :development, phase.development
end

crumb :phase do |phase|
  link phase.name, development_phase_path(phase.development, phase)
  parent :development, phase.development
end

crumb :phase_new do |development|
  link t("breadcrumbs.phase_add")
  parent :development, development
end

crumb :phase_bulk_edit do |phase|
  link t("breadcrumbs.bulk_edit"), phase_path(phase, active_tab: :bulk_edit)
  parent :phase, phase
end

crumb :phase_production do |phase|
  link t("breadcrumbs.production"), phase_path(phase, active_tab: :production)
  parent :phase, phase
end

crumb :phase_release_plots do |phase|
  link t("breadcrumbs.release_plots"), phase_path(phase, active_tab: :release_plots)
  parent :phase, phase
end

crumb :phase_lettings do |phase|
  link t("breadcrumbs.phase_lettings"), phase_path(phase, active_tab: :lettings)
  parent :phase, phase
end

crumb :phase_plots_sync do |phase|
  link t("breadcrumbs.crm_sync"), phase_path(phase, active_tab: :bulk_edit)
  parent :phase, phase
end

crumb :phase_select_plot_docs do |phase|
  link t("breadcrumbs.crm_sync"), phase_path(phase, active_tab: :bulk_edit)
  parent :phase, phase
end

crumb :phase_crm_import do |phase|
  link t("breadcrumbs.crm_import"), phase_path(phase, active_tab: :bulk_edit)
  parent :phase, phase
end

crumb :phase_sync_completion do |phase|
  link t("breadcrumbs.sync_completion"), phase_path(phase, active_tab: :bulk_edit)
  parent :phase, phase
end

crumb :phase_sync_residents do |phase|
  link t("breadcrumbs.sync_residents"), phase_path(phase, active_tab: :bulk_edit)
  parent :phase, phase
end

# DEVELOPMENT CHOICE CONFIGURATIONS

crumb :choice_configurations do |development|
  link t("breadcrumbs.choice_configurations"), development_choice_configurations_path(development)
  parent :development, development
end

crumb :choice_configuration_edit do |choice|
  link t("breadcrumbs.choice_configuration_edit", choice_configuration_name: choice.name), edit_development_choice_configuration_path(choice.development, choice)
  parent :development, choice.development
end

crumb :choice_configuration do |choice|
  link choice.name, development_choice_configuration_path(choice.development, choice)
  parent :development, choice.development
end

crumb :choice_configuration_new do |development|
  link t("breadcrumbs.choice_configuration_add")
  parent :development, development
end

# CHOICE CONFIGURATIONS ROOM COBFIGURATIONS

crumb :room_configurations do |choice_configuration|
  link t("breadcrumbs.room_configurations"), choice_configuration_room_configurations_path(choice_configuration)
  parent :choice_configuration, choice_configuration
end

crumb :room_configuration_edit do |room|
  link t("breadcrumbs.room_configuration_edit", room_configuration_name: room.name), edit_choice_configuration_room_configuration_path(room.choice_configuration, room)
  parent :choice_configuration, room.choice_configuration
end

crumb :room_configuration do |room|
  link room.name, choice_configuration_room_configuration_path(room.choice_configuration, room)
  parent :choice_configuration, room.choice_configuration
end

crumb :room_configuration_new do |choice_configuration|
  link t("breadcrumbs.room_configuration_add")
  parent :choice_configuration, choice_configuration
end

# ROOM CONFIGURATIONS ROOM ITEMS

crumb :room_items do |room_configuration|
  link RoomItem.model_name.human.pluralize, room_configuration_room_items_path(room_configuration)
  parent :room_configuration, room_configuration
end

crumb :room_item_edit do |item|
  link t("breadcrumbs.room_item_edit", room_item_name: item.name), ""
  parent :room_configuration, item.room_configuration
end

crumb :room_item do |item|
  link item, room_configuration_room_items_path(item.room_configuration, item)
  parent :room_configuration, item.room_configuration
end

crumb :room_item_new do |room_configuration|
  link t("breadcrumbs.room_item_add")
  parent :room_configuration, room_configuration
end

# PROGRESSES

crumb :progresses do |phase|
  link t("phases.collection.progresses")
  parent :phase, phase
end

crumb :progress do |plot|
  link t("plots.collection.progress")
  parent :plot, plot
end

# UNIT TYPES

crumb :unit_types do |development|
  link UnitType.model_name.human.pluralize, development_unit_types_path(development)
  parent :development, development
end

crumb :unit_type do |unit_type|
  link unit_type.name, development_unit_type_path(unit_type.development, unit_type)
  parent :development, unit_type.development
end

crumb :unit_type_edit do |unit_type|
  link t("breadcrumbs.unit_type_edit", unit_type_name: unit_type.name), edit_development_unit_type_path(unit_type.development, unit_type)
  parent :development, unit_type.development
end

crumb :unit_type_new do |development|
  link t("breadcrumbs.unit_type_new")
  parent :development, development
end

# DOCUMENTS

crumb :plot_documents do |plot_docs_parent|
  link t("developments.collection.plot_documents")
  case plot_docs_parent.model_name.element.to_sym
    when :development
      parent :development, plot_docs_parent
    when :phase
      parent :phase, plot_docs_parent
  end
end

crumb :document do |document|
  link document.title, document_path
  case document.parent.model_name.element.to_sym
    when :developer
      parent :developer, document.parent
    when :division
      parent :division, document.parent
    when :development
      parent :development, document.parent
    when :phase
      parent :phase, document.parent
    when :plot
      parent :plot, document.parent
    when :unit_type
      parent :unit_type, document.parent
  end
end

crumb :document_edit do |document|
  link t("breadcrumbs.document_edit", document_name: document.title), edit_document_path(document)
  case document.parent.model_name.element.to_sym
    when :developer
      parent :developer, document.parent
    when :division
      parent :division, document.parent
    when :development
      parent :development, document.parent
    when :phase
      parent :phase, document.parent
    when :plot
      parent :plot, document.parent
    when :unit_type
      parent :unit_type, document.parent
  end
end

crumb :document_new do |document_parent|
  link t("breadcrumbs.document_add")

  case document_parent.model_name.element.to_sym
    when :developer
      parent :developer, document_parent
    when :division
      parent :division, document_parent
    when :development
      parent :development, document_parent
    when :phase
      parent :phase, document_parent
    when :plot
      parent :plot, document_parent
    when :unit_type
      parent :unit_type, document_parent
  end
end

# ROOMS
crumb :rooms do |room_parent|
  link Room.model_name.human.pluralize, [room_parent, :rooms]

  case room_parent
  when Plot
    parent :plot, room_parent
  when UnitType
    parent :unit_type, room_parent
  end
end

crumb :room_edit do |room|
  link t("breadcrumbs.room_edit", room_name: room.name), [:edit, room.parent, room]
  parent :room, room
end

crumb :plot_room do |room, plot|
  link room.name, [room.parent, room]
  parent :plot, plot
end

crumb :room do |room|
  link room.name, [room.parent, room]

  case room.parent
  when Plot
    parent :plot, room.plot
  when UnitType
    parent :unit_type, room.unit_type
  end
end

crumb :room_new do |room_parent|
  link t("breadcrumbs.room_add")

  case room_parent
  when Plot
    parent :plot, room_parent
  when UnitType
    parent :unit_type, room_parent
  end
end

crumb :room_finish_edit do |room|
  link t("breadcrumbs.room_finish"), [:edit, room.parent, room]
  parent :room, room
end

crumb :room_appliance_edit do |room|
  link t("breadcrumbs.room_appliance"), [:edit, room.parent, room]
  parent :room, room
end

# PLOTS

crumb :plots do |plot_parent|
  link Plot.model_name.human.pluralize, ([plot_parent, active_tab: :plots])
  parent :phase, plot.parent if plot.parent.is_a? Phase
end

crumb :plot do |plot|
  link plot, plot
  parent :phase, plot.parent if plot.parent.is_a? Phase
end

crumb :plot_preview do |plot|
  link t("plots.show.preview")
  parent :plot, plot
end

crumb :plot_edit do |plot|
  link t("breadcrumbs.plot_edit", plot_name: plot), [:edit, plot]
  parent :phase, plot.parent if plot.parent.is_a? Phase
end

crumb :plot_new do |plot|
  link t("breadcrumbs.plot_add"), [:new, plot.parent, :plot]
  parent :phase, plot.parent if plot.parent.is_a? Phase
end

# PLOT RESIDENCIES
crumb :residents do |plot|
  link t("breadcrumbs.residents"), [plot, active_tab: :residents]
  parent :plot, plot
end

crumb :resident_add do |plot|
  link t("breadcrumbs.resident_add"), [:new, plot, :resident]
  parent :residents, plot
end

crumb :resident_edit do |resident, plot|
  link t("breadcrumbs.resident_edit", name: resident), [:edit, plot, resident]
  parent :residents, plot
end

crumb :resident do |resident, plot|
  link t("breadcrumbs.resident", name: resident), [plot, resident]
  parent :residents, resident.plots.first
end

# FINISHES

crumb :finishes do
  link Finish.model_name.human.pluralize, finishes_path
end

crumb :finish do | finish |
  link finish.name, finish_path(finish)
  parent :finishes
end

crumb :finish_edit do | finish |
  link t("breadcrumbs.finish_edit", name: finish.name)
  parent :finishes
end

crumb :finish_new do
  link t("breadcrumbs.finish_add")
  parent :finishes
end

# FINISH CATEGORIES

crumb :finish_categories do
  link t("breadcrumbs.finish_categories"), finish_categories_path
  parent :finishes
end

crumb :finish_category do | finish_category |
  link finish_category.name, finish_category_path
  parent :finish_categories
end

crumb :finish_category_edit do |finish_category|
  link t("breadcrumbs.finish_category_edit", name: finish_category.name), edit_finish_category_path(finish_category)
  parent :finish_categories
end

crumb :finish_category_new do
  link t("breadcrumbs.finish_category_add")
  parent :finish_categories
end

# FINISH TYPES

crumb :finish_types do
  link t("breadcrumbs.finish_types"), finish_types_path
  parent :finishes
end

crumb :finish_type do | finish_type |
  link finish_type.name, finish_type_path
  parent :finish_types
end

crumb :finish_type_edit do |finish_type|
  link t("breadcrumbs.finish_type_edit", name: finish_type.name), edit_finish_type_path(finish_type)
  parent :finish_types
end

crumb :finish_type_new do
  link t("breadcrumbs.finish_type_add")
  parent :finish_types
end

# APPLIANCES

crumb :appliances do
  link Appliance.model_name.human.pluralize, appliances_path
end

crumb :appliance do |appliance|
  link appliance, edit_appliance_path(appliance)
  parent :appliances
end

crumb :appliance_edit do |appliance|
  link t("breadcrumbs.appliance_edit", name: appliance.full_name), appliances_path(appliance)
  parent :appliances
end

crumb :appliance_new do
  link t("breadcrumbs.appliance_add")
  parent :appliances
end

# FINISH MANUFACTURERS

crumb :finish_manufacturers do
  link t("breadcrumbs.finish_manufacturers"), finish_manufacturers_path
  parent :finishes
end

crumb :finish_manufacturer do | manufacturer |
  link manufacturer.name, finish_manufacturer_path
  parent :finish_manufacturers
end

crumb :finish_manufacturer_edit do |manufacturer|
  link t("breadcrumbs.manufacturer_edit", name: manufacturer.name), edit_finish_manufacturer_path(manufacturer)
  parent :finish_manufacturers
end

crumb :finish_manufacturer_new do
  link t("breadcrumbs.manufacturer_add")
  parent :finish_manufacturers
end

# APPLIANCE MANUFACTURERS

crumb :appliance_manufacturers do
  link t("breadcrumbs.appliance_manufacturers"), appliance_manufacturers_path
  parent :appliances
end

crumb :appliance_manufacturer do | manufacturer |
  link manufacturer.name, appliance_manufacturer_path
  parent :appliance_manufacturers
end

crumb :appliance_manufacturer_edit do |manufacturer|
  link t("breadcrumbs.manufacturer_edit", name: manufacturer.name), edit_appliance_manufacturer_path(manufacturer)
  parent :appliance_manufacturers
end

crumb :appliance_manufacturer_new do
  link t("breadcrumbs.appliance_manufacturer_add")
  parent :appliance_manufacturers
end

# APPLIANCE CATEGORIES
crumb :appliance_categories do
  link t("breadcrumbs.appliance_categories"), appliance_categories_path
  parent :appliances
end

crumb :appliance_category do | appliance_category |
  link appliance_category.name, appliance_category_path
  parent :appliance_categories
end

crumb :appliance_category_edit do |appliance_category|
  link t("breadcrumbs.appliance_category_edit", name: appliance_category.name), edit_appliance_category_path(appliance_category)
  parent :appliance_categories
end

crumb :appliance_category_new do
  link t("breadcrumbs.appliance_category_add")
  parent :appliance_categories
end

# CONTACTS

crumb :contacts do |contact_parent|
  link t("breadcrumbs.contacts"), ([contact_parent, :contacts])

  case contact_parent.model_name.element.to_sym
    when :developer
      parent :developer, contact_parent
    when :division
      parent :division, contact_parent
    when :development
      parent :development, contact_parent
    when :phase
      parent :phase, contact_parent
  end
end

crumb :contact do |contact|
  link t("breadcrumbs.contact_show", contact: contact), contact, contact_path(contact)
  parent :contacts, contact.contactable
end

crumb :contact_edit do |contact|
  link t("breadcrumbs.contact_edit", contact_name: contact), edit_contact_path(contact)
  parent :contacts, contact.contactable
end

crumb :contact_new do |contact_parent|
  link t("breadcrumbs.contact_add")
  parent :contacts, contact_parent
end

# FAQs

crumb :faqs do |faq_parent, faq_type|
  link t("breadcrumbs.faqs", type: faq_type.name), ([faq_parent, :faqs, active_tab: faq_type.id])

  case faq_parent.model_name.element.to_sym
  when :developer
    parent :developer, faq_parent
  when :division
    parent :division, faq_parent
  when :development
    parent :development, faq_parent
  end
end

crumb :faq_add do |faq_parent, faq_type|
  link t("breadcrumbs.faqs_add"), [:new, faq_parent, :faq]
  parent :faqs, faq_parent, faq_type
end

crumb :faq do |faq|
  link faq.question.html_safe, faq_path(faq)
  parent :faqs, faq.faqable, faq.faq_type
end

crumb :faq_edit do |faq|
  link t("breadcrumbs.faqs_edit", faq: faq), [:edit, faq]
  parent :faqs, faq.faqable, faq.faq_type
end

crumb :faqs_sync do |faq_parent, faq_type|
  link t("breadcrumbs.sync_faqs", type: faq_type.name), ([faq_parent, :sync_faqs, active_tab: faq_type.id])
  parent :faqs, faq_parent, faq_type
end

# VIDEOS

crumb :videos do |video_parent|
  link t("breadcrumbs.videos"), ([video_parent, :videos])
  parent :development, video_parent
end

crumb :video_add do |video_parent|
  link t("breadcrumbs.videos_add"), [:new, video_parent, :video]
  parent :videos, video_parent
end

crumb :video do |video|
  link video.title, video_path(video)
  parent :videos, video.videoable
end

crumb :video_edit do |video|
  link t("breadcrumbs.videos_edit", video: video.title), [:edit, video]
  parent :videos, video.videoable
end

# CUSTOM TILES

crumb :custom_tiles do |custom_tile_parent|
  link t("breadcrumbs.custom_tiles"), ([custom_tile_parent, :custom_tiles])
  parent :development, custom_tile_parent
end

crumb :custom_tile_add do |custom_tile_parent|
  link t("breadcrumbs.custom_tile_add"), [:new, custom_tile_parent, :custom_tile]
  parent :custom_tiles, custom_tile_parent
end

crumb :custom_tile do |custom_tile|
  link custom_tile.title? ? custom_tile.title : I18n.t("activerecord.attributes.custom_tiles.features.#{custom_tile.feature}")
  parent :custom_tiles, custom_tile.parent
end

crumb :custom_tile_edit do |custom_tile|
  link t("breadcrumbs.custom_tile_edit",
         tile: custom_tile.title? ? custom_tile.title : I18n.t("activerecord.attributes.custom_tiles.features.#{custom_tile.feature}")), [:edit, custom_tile]
  parent :custom_tiles, custom_tile.parent
end

# SERVICES

crumb :services do |development|
  link t("breadcrumbs.services"), ([development, :services])
  parent :development, development
end

crumb :service_add do |development|
  link t("breadcrumbs.services_add"), [:new, development, :service]
  parent :services, development
end

crumb :service do |service|
  link service.name, [service.development, :service]
  parent :services, service.development
end

crumb :service_edit do |service|
  link t("breadcrumbs.services_edit"), [:edit, service.development, :service]
  parent :services, service.development
end

# Brands

crumb :brands do |brand_parent|
  link t("breadcrumbs.brands"), [brand_parent, :brands]

  case brand_parent.model_name.element.to_sym
    when :developer
      parent :developer, brand_parent
    when :division
      parent :division, brand_parent
    when :development
      parent :development, brand_parent
  end
end

crumb :brand_new do |brand_parent|
  link t("breadcrumbs.brand_add"), [:new, brand_parent, :brand]
  parent :brands, brand_parent
end

crumb :brand do |brand|
  link brand, faq_path(brand)
  parent :brands, brand.brandable
end

crumb :brand_edit do |brand|
  link t("breadcrumbs.brand_edit", name: brand), [:edit, brand.brandable, brand]
  parent :brands, brand.brandable
end

# BRANDED APP
crumb :branded_apps do |branded_app_parent|
  case branded_app_parent.model_name.element.to_sym
    when :developer
      parent :developer, branded_app_parent
  end
end

# TIMELINE

crumb :timelines do |timeline_parent|
  link t("breadcrumbs.timelines"), ([timeline_parent, :timelines])

  case timeline_parent.model_name.element.to_sym
    when :developer
      parent :developer, timeline_parent
  end
end

crumb :timeline do |timeline|
  link t("breadcrumbs.timeline_show", timeline: timeline), timeline, timeline_path(timeline)
  parent :timelines, timeline.timelineable
end

crumb :timeline_edit do |timeline|
  link t("breadcrumbs.timeline_edit", timeline: timeline), edit_timeline_path(timeline)
  parent :timelines, timeline.timelineable
end

crumb :timeline_new do |timeline|
  link t("breadcrumbs.timeline_add"), new_timeline_path(timeline)
  parent :timelines, timeline.timelineable
end

crumb :timeline_import do |developer|
  link t("breadcrumbs.timeline_import"), developer_path(developer)
  parent :developer, developer
end

# TASK

crumb :task do |timeline, task|
  link t("breadcrumbs.task_show", task: task.title), timeline_task_path(timeline, task)
  parent :timeline, task.timeline
end

crumb :task_edit do |timeline, task|
  link t("breadcrumbs.task_edit", task: task.title), edit_timeline_task_path(timeline, task)
  parent :task, timeline, task
end

crumb :task_new do |timeline|
  link t("breadcrumbs.task_add"), timeline_path(timeline)
  parent :timeline, timeline
end

# FINALE

crumb :finale do |timeline, finale|
  link t("breadcrumbs.finale_show"), timeline_finale_path(timeline, finale)
  parent :timeline, timeline
end

crumb :finale_edit do |timeline, finale|
  link t("breadcrumbs.finale_edit"), edit_timeline_finale_path(timeline, finale)
  parent :timeline, timeline, finale
end

crumb :finale_add do |timeline|
  link t("breadcrumbs.finale_add"), timeline_path(timeline)
  parent :timeline, timeline
end
