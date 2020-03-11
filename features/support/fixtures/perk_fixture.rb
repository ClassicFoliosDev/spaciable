module PerkFixture
  module_function

  URL="https://vaboo.co.uk"
  ID="68745"
  ACCESS_KEY="1o73uue-92Lkidfh-Lkaosfjf0-lkajsf9"

  def no_resident_account
    {
      :code => 200,
      :message => "List of users",
      :result => true,
      :data => {"count": 0}
    }
  end

  def basic_resident_account
    {
      :code => 200,
      :message => "List of users",
      :result => true,
      :data => {
        "users": [
          {
            "Id": 2,
            "Email": resident_email,
            "Access Type": "Basic Access"
          }
        ],
        "count": 1
      }
    }
  end

  def no_resident_premium_account
    {
      :code => 200,
      :message => "List of users",
      :result => true,
      :data => {
        "users": [
          {
            "Id": 1,
            "Email": "second@resident.com",
            "Access Type": "Basic Access"
          }
        ],
        "count": 1
      }
    }
  end

  def resident_premium_account
    {
      :code => 200,
      :message => "List of users",
      :result => true,
      :data => {
        "users": [
          {
            "Id": 1,
            "Email": "second@resident.com",
            "Access Type": "Premium Access"
          }
        ],
        "count": 1
      }
    }
  end

  # TO-DO - change this
  def branded_perks_link
    "https://en.wikipedia.org/wiki/Duck"
  end

  def default_perks_link
    "https://spaciable.vaboo.co.uk/login"
  end

  def developer_name
    "Perks Developer"
  end

  def development_name
    "Perks Development"
  end

  def phase_name
    "Perks Phase"
  end

  def unit_type_name
    "2 Bed"
  end

  def plot_name
    "221B"
  end

  def resident_email
    "resident@perks.com"
  end

  def create_perk_resident
    FactoryGirl.create(:development, name: development_name, developer: developer) unless development
    FactoryGirl.create(:phase, name: phase_name, development: development)
    FactoryGirl.create(:unit_type, name: unit_type_name, development: development)
    FactoryGirl.create(:phase_plot, phase: phase, number: plot_name, unit_type: unit_type)
    FactoryGirl.create(:resident, :with_residency, plot: plot, email: resident_email,
                       developer_email_updates: true, invitation_accepted_at: Time.zone.now,
                       ts_and_cs_accepted_at: Time.zone.now)
  end

  def developer
    Developer.find_by(company_name: developer_name)
  end

  def development
    Development.find_by(name: development_name)
  end

  def no_development_id
    ""
  end

  def phase
    Phase.find_by(name: phase_name)
  end

  def unit_type
    UnitType.find_by(name: unit_type_name)
  end

  def plot
    Plot.find_by(number: plot_name)
  end

  def resident
    Resident.find_by(email: resident_email)
  end
end
