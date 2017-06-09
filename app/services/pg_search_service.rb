# frozen_string_literal: true
module PgSearchService
  module_function

  def call(context, search_term)
    results = PgSearch.multisearch(search_term).includes(:searchable)
    result_list = process_results(context, results)

    if result_list.length.zero?
      no_result = { id: "-1", name: I18n.t("admin.search.new.no_match"), type: "", path: "" }
      result_list.push(no_result)
    end

    result_list
  end

  def build_path(context, instance)
    return "" unless instance

    if instance.respond_to?(:parent)
      context.polymorphic_url([instance.parent, instance])
    else
      context.polymorphic_url(instance)
    end
  end

  def process_results(context, results)
    result_list = results.map do |result|
      searchable = result.searchable
      path = build_path(context, searchable)

      {
        id: result.searchable_id,
        type: "#{result.searchable_type} ",
        name: result.content,
        path: path
      }
    end
    result_list
  end
end
