# frozen_string_literal: true

module ExpiryFixture
  module_function

  def create_phase
    country = FactoryGirl.create(:country)
    developer = FactoryGirl.create(:developer, company_name: developer_name, country_id: country.id, )
    division = FactoryGirl.create(:division, division_name: division_name, developer_id: developer.id)
    development = FactoryGirl.create(:development,
                                     name: development_name,
                                     division_id: division.id,
                                     developer_id: developer.id)
    phase = FactoryGirl.create(:phase, name: phase_name, development_id: development.id)
  end

  def create_expired_plots
    phase = Phase.find_by(name: phase_name)

    FactoryGirl.create(:phase_plot,
                       number: plot_number,
                       phase_id: phase.id,
                       prefix: "Flat",
                       completion_release_date: expiry_completion_release_date,
                       validity: validity,
                       extended_access: extended_access)

    FactoryGirl.create(:phase_plot,
                       number: second_plot_number,
                       phase_id: phase.id,
                       prefix: "Flat",
                       completion_release_date: expiry_completion_release_date,
                       validity: validity,
                       extended_access: extended_access)
  end

  def create_live_plot
    phase = Phase.find_by(name: phase_name)

    FactoryGirl.create(:phase_plot,
                       number: live_plot_number,
                       phase_id: phase.id,
                       prefix: "Flat",
                       completion_release_date: Time.zone.now,
                       validity: validity,
                       extended_access: extended_access)
  end

  def create_live_plot_residency
    phase = Phase.find_by(name: HomeownerUserFixture.phase_name)
    second_plot = FactoryGirl.create(:phase_plot, number: second_plot_number, phase_id: phase.id)
    resident = create_second_resident
    FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)
  end

  def create_second_resident
    FactoryGirl.create(
      :resident,
      email: resident_email,
      password: resident_password,
      first_name: first_name,
      last_name: last_name,
      ts_and_cs_accepted_at: Time.zone.now,
      phone_number: resident_phone_num,
      developer_email_updates: 1
    )
  end

  def create_second_residency
    resident = Resident.find_by(email: resident_email)
    plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :tenant)
  end

  def developer_name
    "Expiry Developer"
  end

  def division_name
    "Expiry Division"
  end

  def development_name
    "Expiry Development"
  end

  def phase_name
    "Expiry Phase"
  end

  def fixflo_completion_release_date
    (Time.zone.now - 32.days).to_date
  end

  def expiry_completion_release_date
    (Time.zone.now - 64.days).to_date
  end

  def extended_access
    1
  end

  def validity
    1
  end

  def resident_email
    "email@res.com"
  end

  def resident_password
    "password"
  end

  def first_name
    "Sherlock"
  end

  def last_name
    "Holmes"
  end

  def resident_phone_num
    "01234567890"
  end

  def cf_email
    "admin@cf.com"
  end

  def cf_password
    "123456789"
  end

  def admin_password
    "password"
  end

  def doc_name
    "dummy pdf"
  end

  def document_id
    Document.find_by(title: ExpiryFixture.doc_name).id
  end

  def second_doc_name
    "unit type document"
  end

  def plot_number
    "13"
  end

  def live_plot_number
    "100"
  end

  def second_plot_number
    "221B"
  end

  def faq_title
    "First FAQ"
  end

  def faq_content
    "123"
  end

  def second_faq_title
    "Second FAQ"
  end

  def second_faq_content
    "234"
  end
end