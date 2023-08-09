# frozen_string_literal: true

module DevelopmentFinderService
  def call(params)
    return if params.empty?

    development_matching_path(params)
  end

  module_function

  def development_matching_path(params)
    return unless params[:developer_name]
    return unless params[:development_name]

    developer_name = params[:developer_name].tr("-", " ")
    division_name = params[:division_name].tr("-", " ") if params[:division_name]
    development_name = params[:development_name].tr("-", " ")

    developer = Developer.where("lower(company_name) = ?", developer_name).first
    return unless developer

    if division_name
      find_division_development(developer.id, division_name, development_name)
    else
      find_developer_development(developer.id, development_name)
    end
  end

  def find_division_development(developer_id, division_name, development_name)
    division = Division.where("lower(division_name) = ?", division_name)
                       .where(developer_id: developer_id).first
    return unless division

    Development.where("lower(name) = ?", development_name)
               .where(division_id: division.id).first
  end

  def find_developer_development(developer_id, development_name)
    Development.where("lower(name) = ?", development_name)
               .where(developer_id: [developer_id]).first
  end
end
