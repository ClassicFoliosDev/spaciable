# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Vaboo
  include HTTParty

  # class constants
  ACCESS_KEY = ENV.fetch("VABOO_ACCESS")
  URL = ENV.fetch("VABOO_APP_URL")
  ACCOUNT_ID = ENV.fetch("VABOO_ACCOUNT")
  API = "/api/v4/"
  SUCCESS = "2"
  ERROR = "4"
  TIMEOUT = 10
  TIMEOUT_ERROR = "#{URL} is currently unavailable. Please try again later."
  CONNECT_ERROR = "Failed to create perks account, #{URL} cannot be contacted."
  # access types
  PREMIUM = "Premium Access"
  BASIC = "Basic Access"
  # api keys
  FIRST_NAME = "First Name"
  LAST_NAME = "Last Name"
  EMAIL = "Email"
  ACCESS_TYPE = "Access Type"
  POSTCODE = "Postcode"
  GROUP = "Group"
  EXPIRE_DATE = "Expire Date"
  REFERENCE = "Reference"
  START = "Start Date"
  # spaciable default vaboo link
  SPACIABLE_LOGIN = "https://spaciable.vaboo.co.uk/login"
  VERIFY = false

  # when a resident submits their details to Vaboo their resident record is created
  # email is unique; creation will fail if there is already a user with the given email address
  # rubocop:disable all
  def self.create_account(params)
    plot = Plot.find_by(id: params[:reference])
    begin
      response = HTTParty.post("#{URL}#{API}users",
                               body:
                                 {
                                   access_key: ACCESS_KEY,
                                   account_id: account_number(plot.developer),
                                   "#{FIRST_NAME}": params[:first_name],
                                   "#{LAST_NAME}": params[:last_name],
                                   "#{EMAIL}": params[:email],
                                   "#{ACCESS_TYPE}": params[:access_type],
                                   "#{POSTCODE}": params[:postcode],
                                   "#{GROUP}": params[:group],
                                   "#{EXPIRE_DATE}": params[:expire_date],
                                   "#{REFERENCE}": params[:reference]
                                 }.to_json,
                               headers:
                                 {
                                   "Content-Type" => "application/json"
                                 },
                               timeout: TIMEOUT,
                               verify: VERIFY)

      yield error unless response.code == 200

      error = nil
      if response.parsed_response["code"].to_s.split("")[0] == ERROR
        error = "Failed to create perks account. #{response.parsed_response['message']['errors']['Email']}"
      end
    rescue Net::OpenTimeout
      error = TIMEOUT_ERROR
    rescue
      error = CONNECT_ERROR
    end

    yield error
  end
  # rubocop:enable all

  def self.check_expired_premium
    # check the spaciable perks portal and each of the branded perks portals
    # create an array of account numbers
    account_ids = [ACCOUNT_ID]
    BrandedPerk.all.find_each do |bp|
      account_ids << bp.account_number if bp.account_number.present?
    end

    # iterate over each account number
    account_ids.each do |id|
      # call the API to get all the residents with premium access
      # (adding expire date as a parameter does not return correctly)
      full_url = "#{URL}#{API}users/#{id}/#{ACCESS_KEY}?#{ACCESS_TYPE}=#{PREMIUM}"

      response = HTTParty.get(full_url, verify: VERIFY)

      response.parsed_response["data"]["users"].each do |user|
        downgrade_expired_premium(user, id) if user[EXPIRE_DATE] == Time.zone.today.to_s
      end
    end
  end

  def self.downgrade_expired_premium(user, id)
    user_id = user["Id"]
    HTTParty.put("#{URL}#{API}users/#{user_id}",
                 body:
                   {
                     access_key: ACCESS_KEY,
                     account_id: id,
                     "#{ACCESS_TYPE}": BASIC
                   }.to_json,
                 headers:
                   {
                     "Content-Type" => "application/json"
                   },
                 timeout: TIMEOUT)
    DowngradePerksAccountJob.perform_later(user[FIRST_NAME], user[EMAIL], id)
  end

  # Does the resident have a perks account?
  def self.perks_account_activated?(resident, plot)
    activated = error = false

    return unless resident
    account_id = account_number(plot.developer)

    full_url = "#{URL}#{API}users/#{account_id}/#{ACCESS_KEY}?#{EMAIL}=#{resident.email}"

    # call the API to find out whether the current resident has a perks account
    begin
      response = HTTParty.get(full_url, verify: VERIFY)
      if response.code == 200
        activated = response.parsed_response["data"]["count"] == 1
      end
    rescue
      error = true
    end
    yield activated, error
  end

  # Has another resident on the plot registered for premium perks?
  # This check is only made after perks_account_activated has succeeded,
  # so does not require a rescue
  def self.premium_perks_activated?(plot)
    account_id = account_number(plot.developer)

    full_url = "#{URL}#{API}users/#{account_id}/#{ACCESS_KEY}?#{REFERENCE}=#{plot.id}"

    #  call the API to find out whether another resident of the plot
    #  has been allocated a premium licence
    response = HTTParty.get(full_url, verify: VERIFY)
    return false unless response.code == 200

    # will return false if api call throws an error
    response.parsed_response["data"]["users"].each do |user|
      return true if user[ACCESS_TYPE] == PREMIUM
    end
    false
  end

  # What type of perk (basic, premium) does the resident have (on the plot)? Used in analytics.
  def self.perk_type_registered(resident, plot)
    return unless resident && plot.enable_perks?
    account_id = account_number(plot.developer)

    # call the API to check the access type that the resident has requested (basic/premium)
    url_params = "?#{EMAIL}=#{resident.email}&#{REFERENCE}=#{plot.id}"

    full_url = "#{URL}#{API}users/#{account_id}/#{ACCESS_KEY}#{url_params}"

    begin
      response = HTTParty.get(full_url, verify: VERIFY)
      return "Not Requested" unless response.code == 200

      # return "Not Requested" if resident record not found (resident has not signed up for perks)
      return "Not Requested" unless response.parsed_response["data"]["count"].positive?

      # return perk type
      response.parsed_response["data"]["users"][0][ACCESS_TYPE]
    rescue
      return "Unknown"
    end
  end

  def self.available_premium_licences(development)
    return unless development.enable_premium_perks
    development.premium_licences_bought - development.premium_perk_sign_up_count
  end

  #### LOCAL CALLS ####

  # Are premium perks available to residents on the plot?
  def self.premium_perks_available?(resident, plot)
    return false unless resident
    plot.enable_premium_perks && resident.plot_residency_homeowner?(plot) &&
      available_premium_licences(plot.development).positive?
  end

  # Spaciable-default or developer-specific login URL
  def self.branded_perks_link(developer)
    developer.branded_perk_link || SPACIABLE_LOGIN
  end

  def self.perk_expire_date(plot)
    if plot.enable_premium_perks
      Time.zone.today + plot.development.premium_licence_duration.months
    else
      plot.expiry_date
    end
  end

  # Does the Developer have a branded account number?
  def self.account_number(developer)
    developer.branded_perk_account_number || ENV.fetch("VABOO_ACCOUNT")
  end

  def self.perk_type(plot)
    return unless RequestStore.store[:current_resident]
    # if Premium is available on the plot for the current resident
    if Vaboo.premium_perks_available?(RequestStore.store[:current_resident], plot)
      # has the plot reached legal completion?
      if plot.completed?
        # if another resident on the plot has activated Premium
        if Vaboo.premium_perks_activated?(plot)
          "basic"
        # if no other resident on the plot has activated Premium
        else
          "premium"
        end
      # if Premium is available on the plot but the plot has not reached legal completion
      else
        "coming_soon"
      end
    # if Premium is not available on the plot regardless if the plot has reached legal completion
    else
      "basic"
    end
  end
end
# rubocop:enable Metrics/ClassLength
