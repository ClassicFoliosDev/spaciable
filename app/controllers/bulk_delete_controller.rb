# frozen_string_literal: true

class BulkDeleteController < ApplicationController
  load_and_authorize_resource :phase

  def index
    return redirect_to root_path unless can? :bulk_delete, @phase

    @active_tab = "bulk_delete"
  end

  def documents
      results = []
      documents = Document.left_joins(:plot).where(plots: {phase_id: @phase.id})
      documents = documents.where(category: params[:category]) unless params[:category] == "all"
      if params[:category] == "my_home" && params[:guide] != "all"
        documents = documents.where(guide: nil) if params[:guide] == "none"
        documents = documents.where(guide: params[:guide]) if params[:guide] != "none"
      end
      documents = documents.select('plots.number as number, documents.id, title, category, guide')
                           .sort_by(&:number)

      documents.each do |doc|
        results << { "number" => doc.number, 
                     "id" => doc.id, 
                     "title" => doc.title,
                     "category" => I18n.t(doc.category, scope: "activerecord.attributes.document.categories", construction: "Home"),
                     "guide" => doc.guide.nil? ? "" : I18n.t(doc.guide, scope: "activerecord.attributes.document.guides")}
      end


      render json: results
    end

end
