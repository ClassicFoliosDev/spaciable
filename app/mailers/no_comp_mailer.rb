# frozen_string_literal: true

class NoCompMailer < ApplicationMailer
  default from: "hello@spaciable.com"

  def no_comp_since_last_res(development, plots)
    @development = development.name
    @plots = plots.pluck(:number).join(",")

    mail to: development.call_off_users.map { |e| e[:email] },
         subject: "Spaciable call off reminder",
         cc: ["hello@spaciable.com, customerexperience@classicfolios.com"]
  end

  def no_comp_since_last_comp(development, plots)
    @development = development.name
    @num_plots = plots.count
    @plots = plots.pluck(:number).join(",")

    mail to: development.call_off_users.map { |e| e[:email] },
         subject: "Spaciable call off reminder",
         cc: ["hello@spaciable.com, customerexperience@classicfolios.com"]
  end
end
