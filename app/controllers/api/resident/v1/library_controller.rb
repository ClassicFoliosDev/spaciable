# frozen_string_literal: true
require 'json'

module Api
  module Resident
    module V1
      class LibraryController < Api::Resident::ResidentController

        BASE = "/api/resident/library/"

        def index
          @categories = []
          
          %w[categories appliance video my_docs].each {|t| self.send("add_#{t}")}

          render json: @categories.to_json, status: :ok
        end

        def category
          documents = Document.accessible_by(current_ability)
                              .where(category: params[:name])
                              .order(pinned: :desc, updated_at: :desc)
          docs = []
          documents.each do |doc|
            docs << {
              id: id,
              link: doc.file_url,
              preview: doc.file.preview.present? ? doc.file.preview.url(response_content_type: %( "image/jpeg" )) : nil,
              title: doc.title,
              video: false
            }
          end

          render json: docs.to_json, status: :ok
        end

        def appliances
          docs = []
          Appliance.accessible_by(current_ability).each do |app|
            %w[manual guide].each do |doc_type|
              doc = app.send(doc_type)
              next unless doc.present?
              docs << {
                id: id,
                link: doc.url,
                preview: doc.preview.present? ? doc.preview.url(response_content_type: %( "image/jpeg" )) : nil,
                title: "#{app.full_name} #{doc_type}",
                video: false
              }
            end
          end

          render json: docs.to_json, status: :ok
        end

        def videos
          vids = []
          @plot&.package_videos.each do |vid|
            vids << {
              id: id,
              link: vid.link,
              preview: "",
              title: vid.title,
              video: true
            }
          end

          render json: vids.to_json, status: :ok
        end

        def my_documents
          docs = []
          PrivateDocument.accessible_by(current_ability).each do |doc|
            docs << {
              id: id,
              link: doc.file_url,
              preview: nil,
              title: doc.title,
              video: false
            }
          end

          render json: docs.to_json, status: :ok
        end
                   
        private

        def add_categories
          Document.categories.each do |cat, num|
            if  Document.of_cat_visible_on_plot(current_ability, cat, @plot).any?
              @categories << { id: id,
                               title: I18n.t("activerecord.attributes.document.categories.#{cat.to_str}", construction: @plot.construction),
                               link: "#{BASE}category/#{cat.to_str}"
                             }
            end
          end
        end

        def add_appliance
          return unless Appliance.accessible_by(current_ability).any?

          @categories << { 
            id: id,
            title: I18n.t("components.homeowner.library_categories.appliances"),
            link: BASE + "appliances"
          }
        end

        def add_video
          return unless @plot.package_videos.any?

          @categories << { 
            id: id,
            title: I18n.t("components.homeowner.library_categories.videos"),
            link: BASE + "videos"
          }
        end

        def add_my_docs
          @categories << { 
            id: id,
            title: I18n.t("components.homeowner.library_categories.my_documents"),
            link: BASE + "my_docs"
          }
        end

        def id
          @id ||= 0
          @id += 1
        end

      end
    end
  end
end
