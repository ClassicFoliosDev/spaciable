# frozen_string_literal: true

module PaginationConcern
  extend ActiveSupport::Concern

  included do
    def per_page?(num)
      @per_page.to_i == num.to_i
    end
    helper_method :per_page?
  end

  def paginate(resource)
    per = params[:per].presence || 25
    page = params[:page].presence || 1

    @per_page = per
    resource&.page(page)&.per(per)
  end
end
