crumb :root do
  link "Dashboard", root_path
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
  link t("breadcrumbs.admin_user_edit", user_email: user.email), edit_admin_user_path(user)
  parent :admin_users
end

crumb :admin_user do |user|
  link user.to_s, admin_user_path(user)
  parent :admin_users
end

# Admin Notifications
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
  link Division.model_name.human.pluralize, developer_divisions_path(developer)
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

crumb :document do |document|
  link document.title, document_path
  case document.parent.model_name.element.to_sym
    when :developer
      parent :developer, document.parent
    when :division
      parent :division, document.parent
    when :development
      parent :development, document.parent
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

# PLOTS

crumb :plots do |plot_parent|
  if plot_parent.is_a? Development
    link Plot.model_name.human.pluralize, development_plots_path(plot_parent)
    parent :development, plot_parent
  elsif plot_parent.is_a? Phase
    link Plot.model_name.human.pluralize, phase_plots_path(plot_parent)
    parent :phase, plot_parent
  end
end

crumb :plot do |plot|
  link plot, plot
  parent :plots, plot.parent
end

crumb :plot_edit do |plot|
  link t("breadcrumbs.plot_edit", plot_name: plot), [:edit, plot]
  parent :plots, plot.parent
end

crumb :plot_new do |plot|
  link t("breadcrumbs.plot_add"), [:new, plot.parent, :plot]
  parent :plots, plot.parent
end

# PLOT RESIDENCIES
crumb :plot_residencies do |plot|
  link t("breadcrumbs.plot_residencies"), [plot, :plot_residencies]
  parent :plot, plot
end

crumb :plot_residency_add do |plot|
  link t("breadcrumbs.plot_residency_add"), [:new, plot, :plot_residency]
  parent :plot_residencies, plot
end

crumb :plot_residency_edit do |plot_residency|
  link t("breadcrumbs.plot_residency_edit", plot: plot_residency.plot), [:edit, plot_residency]
  parent :plot_residencies, plot_residency.plot
end

crumb :plot_residency do |plot_residency|
  link t("breadcrumbs.plot_residency", residency: plot_residency), plot_residency
  parent :plot_residencies, plot_residency.plot
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

# APPLIANCES

crumb :appliances do
  link Appliance.model_name.human.pluralize, appliances_path
end

crumb :appliance do |appliance|
  link appliance, edit_appliance_path(appliance)
  parent :appliances
end

crumb :appliance_edit do |appliance|
  link t("breadcrumbs.appliance_edit", name: appliance.name), appliances_path(appliance)
  parent :appliances
end

crumb :appliance_new do
  link t("breadcrumbs.appliance_add")
  parent :appliances
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
  end
end

crumb :contact do |contact|
  link contact, contact_path(contact)
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

crumb :faqs do |faq_parent|
  link t("breadcrumbs.faqs"), ([faq_parent, :faqs])

  case faq_parent.model_name.element.to_sym
  when :developer
    parent :developer, faq_parent
  when :division
    parent :division, faq_parent
  when :development
    parent :development, faq_parent
  end
end

crumb :faq_add do |faq_parent|
  link t("breadcrumbs.faqs_add"), [:new, faq_parent, :faq]
  parent :faqs, faq_parent
end

crumb :faq do |faq|
  link faq, faq_path(faq)
  parent :faqs, faq.faqable
end

crumb :faq_edit do |faq|
  link t("breadcrumbs.faqs_edit"), [:edit, faq]
  parent :faqs, faq.faqable
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
  link t("breadcrumbs.brand_add", name: brand_parent), [:new, brand_parent, :brand]
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
