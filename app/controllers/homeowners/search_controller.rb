# frozen_string_literal: true

module Homeowners
  class SearchController < Homeowners::BaseController
    include SearchConcern
    def new
      result_list = search_types(params[:search_term])

      if result_list.length.zero?
        no_result = { id: "-1", name: I18n.t("admin.search.new.no_match"), type: "", path: "" }
        result_list.push(no_result)
      end

      render json: result_list
    end

    private

    def search_types(search_term)
      appliances = appliance_search(search_term)

      search_results = {
        Appliance: appliances,
        Manual: appliances.reject { |a| a.manual.blank? && a.guide.blank? },
        Finish: finish_search(search_term),
        Room: room_search(search_term),
        Document: document_search(search_term),
        Faq: faq_search(search_term),
        Contact: contact_search(search_term),
        Notification: notification_search(search_term),
        HowTo: how_to_search(search_term)
      }

      HomeownerSearchSerializer.build(self, search_results)
    end
  end
end
