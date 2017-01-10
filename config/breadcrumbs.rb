crumb :root do
  link "Dashboard", root_path
end

# DEVELOPERS

crumb :developers do
  link Developer.model_name.human.pluralize, developers_path
end

crumb :developer do |developer|
  # Replace this with a tabbed view of divisions / developments for the developer,
  # as there is no show developer page to visit.
  link developer, edit_developer_path(developer)
  parent :developers
end

crumb :developer_edit do |developer|
  link t("breadcrumbs.developer_edit", developer_name: developer.company_name), developers_path(developer)
  parent :developers
end

crumb :developer_new do
  link t("views.add_type",
         type: Developer.model_name.human)
  parent :developers
end

# DIVISIONS

crumb :developer_divisions do |developer|
  link Division.model_name.human.pluralize, developer_divisions_path(developer)
  parent :developer, developer
end

crumb :divisions do |developer|
  link Division.model_name.human.pluralize, developer_divisions_path(developer.id)
  parent :developer, developer
end

crumb :division do |division|
  link division, [:edit, division.developer, division]
  parent :divisions, division.developer
end

crumb :developer_division_edit do |division|
  title = t("breadcrumbs.division_edit", division_name: division.division_name)

  link title, edit_developer_division_path(division.developer, division)
  parent :developer_divisions, division.developer
end

crumb :division_new do |developer|
  link t("views.add_type",
         type: Division.model_name.human)
  parent :divisions, developer
end

# DEVELOPMENTS

crumb :development_edit do |development|
  title = t("breadcrumbs.development_edit", development_name: development.name)

  if development.parent.is_a?(Developer)

    link title, edit_developer_development_path(development.parent, development)
    parent :developer_developments, development.parent

  elsif development.parent.is_a?(Division)

    link title, edit_division_development_path(development.parent, development)
    parent :division_developments, development.parent
  end
end

crumb :developer_developments do |developer|
  link Development.model_name.human.pluralize, developer_developments_path(developer)
  parent :developer, developer
end

crumb :development_new do |development_parent|
  link t("breadcrumbs.development_new")

  case development_parent
  when Developer
    parent :developer_developments, development_parent
  when Division
    parent :division_developments, development_parent
  end
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
  link t("views.edit"), edit_development_phase_path(phase.development, phase)
  parent :phases, phase.development
end

crumb :phase_new do |development|
  link t("views.add_type",
         type: Phase.model_name.human)
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
  link t("views.edit")
  parent :document, document
end

crumb :document_new do
  link t("views.add_type",
         type: Document.model_name.human)
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
  link t("views.edit")
  parent :user, user
end

crumb :user_new do
  link t("views.add_type",
         type: User.model_name.human)
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
  link t("views.add_type",
         type: Room.model_name.human)
  parent :rooms, unit_type
end

# PLOTS

crumb :plots do |development|
  link Plot.model_name.human.pluralize, development_plots_path
  parent :development_edit, development
end

crumb :plot_edit do |plot|
  link t("breadcrumbs.plot_edit", plot_name: plot)
  parent :plots, plot.development
end

crumb :plot_new do |plot, development, developer|
  link t("breadcrumbs.plot_new")
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
  link t("views.edit")
  parent :finish, finish, development, developer
end

crumb :finish_new do |development, developer|
  link t("views.add_type",
         type: Finish.model_name.human)
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
