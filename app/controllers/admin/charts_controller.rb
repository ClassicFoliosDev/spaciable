# frozen_string_literal: true

module Admin
  class ChartsController < ApplicationController
    skip_authorization_check

    def chartdata
      current_user.update(selections: chart_params.to_h.inject("") { |s, k| s + k[0] + k[1] })
      results = {}
      results[:primary] = {
        invited: numplots(:invited),
        activated: numplots(:activated),
        not_invited: numplots(:not_invited)
      }

      results[:competition] = competitions unless chart_params[:developer] == "0"

      render json: results
    end

    private

    def numplots(criteria)
      plots(chart_params[:developer].to_i,
            chart_params[:division].to_i,
            chart_params[:development].to_i,
            chart_params[:phase].to_i,
            criteria)
    end

    # Go through all developments and calculate invited/activated values.
    # Sum them up at division level
    def competitions
      results = {}
      developer = Developer.find(chart_params[:developer].to_i)

      # developer develpments placed under division 0
      results[0] = competition(developer, 0)
      developer.divisions.each { |d| results[d.id] = competition(d) }
      results
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def competition(container, id = nil)
      results = { name: container.identity, id: (id || container.id),
                  invited: 0, activated: 0, percent: 0 }

      container.send("developments").each do |development|
        invited = plots(0, 0, development.id, 0, :invited)
        activated = plots(0, 0, development.id, 0, :activated)

        next unless invited.positive?

        results[development.id] = {
          name: development.name, id: development.id, div_id: (development&.division&.id || 0),
          percent: invited.zero? ? 0 : (activated.to_f / invited * 100.0)
        }
        results[:invited] += invited
        results[:activated] += activated
        results[:percent] = if results[:invited].zero?
                              0
                            else
                              (results[:activated].to_f / results[:invited] * 100.0)
                            end
      end
      results
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def chart_params
      params.permit(
        :developer,
        :division,
        :development,
        :phase
      )
    end

    def plots(developer, division, development, phase, criteria)
      Chart.plots(developer, division, development, phase, criteria)
           .reject(&:expired?).count
    end
  end
end
