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
    per = params[:per].blank? ? 25 : params[:per]
    page = params[:page].blank? ? 1 : params[:page]

    @per_page = per
    resource&.page(page)&.per(per)
  end
end
