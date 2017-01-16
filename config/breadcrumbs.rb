crumb :root do
  link "Dashboard", root_path
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
  parent :developments, development.parent

  if development.parent.is_a?(Developer)
    link title, edit_developer_development_path(development.parent, development)
  elsif development.parent.is_a?(Division)
    link title, edit_division_development_path(development.parent, development)
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
  parent :development_edit, development
end

crumb :phase_edit do |phase|
  link t("breadcrumbs.phase_edit", phase_name: phase.name), edit_development_phase_path(phase.development, phase)
  parent :phases, phase.development
end

crumb :phase_new do |development|
  link t("breadcrumbs.phase_add")
  parent :phases, development
end

# UNIT TYPES

crumb :unit_types do |development|
  link UnitType.model_name.human.pluralize, development_unit_types_path(development)
  parent :development_edit, development
end

crumb :unit_type_edit do |unit_type|
  link t("breadcrumbs.unit_type_edit", unit_type_name: unit_type.name), edit_development_unit_type_path(unit_type.development, unit_type)
  parent :unit_types, unit_type.development
end

crumb :unit_type_new do |development|
  link t("breadcrumbs.unit_type_new")
  parent :unit_types, development
end

# DOCUMENTS

crumb :documents do
  link Document.model_name.human.pluralize, documents_path
end

crumb :document do |document|
  link document.title, document_path
  parent :documents
end

crumb :document_edit do |document|
  link t(".edit")
  parent :document, document
end

crumb :document_new do
  link t("breadcrumbs.document_add")
  parent :documents
end

# USERS

crumb :users do
  link User.model_name.human.pluralize, users_path
end

crumb :user do |user|
  link "%{first_name} %{last_name}" % {
    first_name: user.first_name,
    last_name: user.last_name
  }, user_path
  parent :users
end

crumb :user_edit do |user|
  link t(".edit")
  parent :user, user
end

crumb :user_new do
  link t("breadcrumbs.user_add")
  parent :users
end

# ROOMS

crumb :rooms do |unit_type|
  link Room.model_name.human.pluralize, unit_type_rooms_path(unit_type)
  parent :unit_type_edit, unit_type
end

crumb :room_edit do |room|
  link t("breadcrumbs.room_edit", room_name: room.name), edit_room_path(room)
  parent :rooms, room.unit_type
end

crumb :room_new do |unit_type|
  link t("breadcrumbs.room_add")
  parent :rooms, unit_type
end

# PLOTS

crumb :plots do |plot_parent|
  if plot_parent.is_a? Development
    link Plot.model_name.human.pluralize, development_plots_path(plot_parent)
    parent :development_edit, plot_parent
  elsif plot_parent.is_a? Phase
    link Plot.model_name.human.pluralize, phase_plots_path(plot_parent)
    parent :phase_edit, plot_parent
  end
end

crumb :plot_edit do |plot|
  link t("breadcrumbs.plot_edit", plot_name: plot)
  parent :plots, plot.development
end

crumb :plot_new do |plot, development, developer|
  link t("breadcrumbs.plot_add")
  parent :plots, plot, development, developer
end

# FINISHES

crumb :finishes do |development, developer|
  link Finish.model_name.human.pluralize, room_finishes_path
  parent :rooms, development, developer
end

crumb :finish do |finish, development, developer|
  link finish.name, room_finish_path
  parent :finishes, development, developer
end

crumb :finish_edit do |finish, development, developer|
  link t(".edit")
  parent :finish, finish, development, developer
end

crumb :finish_new do |development, developer|
  link t("breadcrumbs.finish_add")
  parent :finishes, development, developer
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
