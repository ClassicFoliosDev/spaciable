# frozen_string_literal: true

module SnagFixture
  module_function

  def create_snag(plot)
    FactoryGirl.create(:snag,
                       title: title,
                       description: description,
                       plot_id: plot.id)
    plot.update_attributes(total_snags: 1)
    plot.update_attributes(unresolved_snags: 1)
    plot.phase.update_attributes(unresolved_snags: 1)
  end

  def second_resident
    FactoryGirl.create(:resident,
                       first_name: resident_first_name,
                       last_name: resident_last_name,
                       email: resident_email,
                       ts_and_cs_accepted_at: Time.zone.now
                      )
  end

  def title
    "Test Snag"
  end

  def updated_title
    "Test Snag Updated"
  end

  def second_title
    "Second title"
  end

  def description
    "Hello this is an issue I am having there are nails everywhere help"
  end

  def updated_description
    "Hello the nails are everywhere they are toenails not hammer nails"
  end

  def second_description
    "Second description"
  end

  def comment
    "Test comment"
  end

  def admin_comment
    "Admin test comment"
  end

  def resident_first_name
    "Benedink"
  end

  def resident_last_name
    "Cumbuster"
  end

  def resident_email
    "benedink@email.com"
  end

  def notification_email
    "notification@email.com"
  end

  def no_notification_email
    "no_notification@email.com"
  end

  def developer
    Developer.find_by(company_name: developer_name)
  end

  def developer_name
    "Snagging Developer"
  end

  def developer_email
    "developer@email.com"
  end

  def division_name
    "Snagging Division"
  end

  def development_name
    "Snagging Development"
  end

  def development_email
    "development@email.com"
  end

  def admin_password
    "012345678"
  end

  def first_name
    "Christian"
  end

  def last_name
    "Surname"
  end
end