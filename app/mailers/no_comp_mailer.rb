# frozen_string_literal: true

class NoCompMailer < ApplicationMailer
  default from: "feedback@spaciable.com"

  def no_comp_since_last_res(development, plots)
    @development = development.name
    @plots = plots.pluck(:number).join(",")

    mail to: "me@gmail.com",
         subject: "no comp"
  end

  def no_comp_since_last_comp(development, plots)
    @development = development.name
    @num_plots = plots.count
    @plots = plots.pluck(:number).join(",")

    mail to: "me@gmail.com",
         subject: "no comp since comp"
  end
end
