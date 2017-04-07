class ResidentMarketingEmailsService
  def self.new_test(email = "joe.james@alliants.com", plot: Plot.last, first_name: "Joe", last_name: "James")
    resident = Resident.new(email: email, plot: plot, first_name: first_name, last_name: last_name)

    new(resident)
  end

  def initialize(resident)
    @resident = resident
  end
  attr_reader :resident

  def resident_assigned_to_plot
    response = list.members(md5_hashed_email).upsert(
      body: {
        email_address: resident.email,
        status: "subscribed",
        merge_fields: merge_fields.merge(HOOZSTATUS: "unactivated")
      }
    )

    puts response.body
  end

  def resident_activated
    response = list.members(md5_hashed_email).upsert(
      body: {
        email_address: resident.email,
        status: "subscribed",
        merge_fields: merge_fields.merge(HOOZSTATUS: "activated")
      }
    )

    puts response.body
  end

  private

  def md5_hashed_email
    Digest::MD5.hexdigest(resident.email.downcase)
  end

  def merge_fields
    plot = resident.plot

    {
      FNAME: resident.first_name,
      LNAME: resident.last_name,
      DEVELOPER: plot.developer.to_s,
      DIVISION: plot.division.to_s,
      DEVELOPMEN: plot.development.to_s,
      PHASE: plot.phase.to_s,
      PLOTNUM: plot.number.to_s,
      PLOTPREFIX: plot.prefix.to_s
    }
  end

  def list
    client.lists("91418e8697")
  end

  def client
    Gibbon::Request.new(api_key: "522789ebd4b820cb56afa47a96d01da1-us14", symbolize_keys: true)
  end
end
