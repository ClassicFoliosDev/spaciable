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

crumb :developments do |developer|
  link Development.model_name.human.pluralize, developer_developments_path(developer)
  parent :developer, developer
end

crumb :developer_developments do |developer|
  link Development.model_name.human.pluralize, developer_developments_path(developer)
  parent :developer, developer
end

crumb :development do |development, developer|
  link development.name, [developer, development]
  parent :developments, developer
end

crumb :development_new do |developer|
  link t("breadcrumbs.development_new")
  parent :developments, developer
end

# DIVISION DEVELOPMENTS

crumb :division_developments do |division|
  link Development.model_name.human.pluralize, division_developments_path(division)
  parent :division, division
end

crumb :division_development_new do |division|
  link t("views.add_type",
         type: Development.model_name.human)
  parent :division_developments, division
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

crumb :unit_types do |development, developer|
  link UnitType.model_name.human.pluralize, development_unit_types_path
  parent :development, development, developer
end

crumb :unit_type do |unit_type, development, developer|
  link unit_type.name, development_unit_type_path
  parent :unit_types, development, developer
end

crumb :unit_type_edit do |unit_type, development, developer|
  link t("views.edit")
  parent :unit_type, unit_type, development, developer
end

crumb :unit_type_new do |development, developer|
  link t("views.add_type",
         type: UnitType.model_name.human)
  parent :unit_types, development, developer
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

crumb :rooms do |development, developer|
  link Room.model_name.human.pluralize, development_rooms_path(development)
  parent :development, development, developer
end

crumb :room do |room, development, developer|
  link room.name, development_rooms_path(room)
  parent :rooms, development, developer
end

crumb :room_edit do |room, development, developer|
  link t("views.edit")
  parent :room, room, development, developer
end

crumb :room_new do |development, developer|
  link t("views.add_type",
         type: Room.model_name.human)
  parent :rooms, development, developer
end

# PLOTS

crumb :plots do |development, developer|
  link Plot.model_name.human.pluralize, development_plots_path
  parent :development, development, developer
end

crumb :plot do |plot, development, developer|
  link "%{prefix} %{number}" % {
    prefix: plot.prefix,
    number: plot.number
  }, development_plot_path(plot)
  parent :plots, development, developer
end

crumb :plot_edit do |plot, development, developer|
  link t("views.edit")
  parent :plot, plot, development, developer
end

crumb :plot_new do |plot, development, developer|
  link t("views.add_type",
         type: Plot.model_name.human)
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
