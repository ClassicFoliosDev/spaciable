# frozen_string_literal: true

# rubocop:disable all
class PlanetRent
  include HTTParty

  # class constants
  ID = ENV.fetch("PLANET_RENT_APP_ID")
  SECRET = ENV.fetch("PLANET_RENT_APP_SECRET")
  URL = ENV.fetch("PLANET_RENT_APP_URL")
  SUCCESS = "2"
  ERROR = "4"
  API = "/api/v3/"
  BASE_URL = "https://spaciable.ngrok.io"
  CALLBACK = "#{BASE_URL}/users/auth/doorkeeper/callback"
  TIMEOUT = 10
  TIMEOUT_ERROR = "#{URL} is currently unavaliable. Please try again later"
  CONNECT_ERROR = "#{URL} cannot be contacted"

  # Ensures we only process valid authorisations.  The nonse is sent
  # with the authorisation request as the 'state' parameter.  The
  # nonce is then stored in the session. The response is compared
  # with the value the session to check they are the same
  class State
    require "securerandom"
    attr_accessor :nonce
    attr_accessor :redirect_url

    def initialize(redirect)
      @redirect_url = redirect
      @nonce = SecureRandom.hex(32)
    end

    def matches?(nonce)
      self.nonce = nonce
    end
  end

  class << self
    # rubocop:disable all
    # Add a landlord account.  These should always return
    # success as long as the connection is available.  A new user is
    # always geenrated regardless of if their details are duplicates
    # of an existing user.  They will just be allocated a
    # unique username
    def add_landlord(params)
      management = LettingsAccount.restricted? params[:management]

      begin
        response = HTTParty.post("#{URL}#{API}create_landlord",
          body:
            {
              user:
              {
                first_name: params[:first_name],
                last_name: params[:last_name],
                email:  params[:email],
                restricted: management
              }
            }.to_json,
          headers:
            {
              "Content-Type" => "application/json",
              "Accept" => "application/json"
            },
          timeout: TIMEOUT)

        data = error = nil
        if response.headers["status"].start_with? ERROR
          error = "Failed to create landlord. #{response.parsed_response['errors']}"
        else
          data = response.parsed_response["data"]
        end
      rescue Net::OpenTimeout
        error = TIMEOUT_ERROR
      rescue
        error = CONNECT_ERROR
      end

      yield data, error
    end

    # Let a property.
    def let_property(user, params)
      data = error = nil

      if user.account?
        token = user.lettings_account.access_token.refresh!

        begin
          response = HTTParty.post("#{URL}#{API}let_property",
            body:
            {
              access_token: token.access_token,
              property:
              [{
                other_ref: params[:other_ref],
                address_1: params[:address_1],
                address_2: params[:address_2],
                postcode: params[:postcode],
                country: params[:country],
                town: params[:town],
                bathrooms: params[:bathrooms],
                bedrooms: params[:bedrooms],
                landlord_pets_policy: params[:landlord_pets_policy],
                has_car_parking: params[:has_car_parking],
                has_bike_parking: params[:has_bike_parking],
                property_type: params[:property_type],
                price: params[:price],
                shared_accommodation: params[:shared_accommodation],
                notes: params[:notes],
                summary: params[:summary],
                landlord_reference: params[:landlord]
              }]
            }.to_json,
            headers:
            {
              "Content-Type" => "application/json",
              "Accept" => "application/json"
            },
            timeout: TIMEOUT)

          if response.headers["status"].start_with? ERROR
              details = response.parsed_response["errors"].map { |e| "#{e}" }.to_sentence
              error = "Failed to create listing.  #{details}"
          else
            data = response.parsed_response["data"][0]
            if data["status"] == false
              details = data["errors"].map { |k, v| "#{k} #{v[0]}" }.to_sentence
              error = "Failed to create listing.  #{details}"
            end
          end
        rescue Net::OpenTimeout
          error = TIMEOUT_ERROR
        rescue
          error = CONNECT_ERROR
        end

      end

      yield data, error
    end

    # Get the user info associated with the provided token
    def user_info(oauth_token)
      data = error = nil

      begin
        response = HTTParty.get("#{URL}#{API}get_user_info?access_token=#{oauth_token.token}",
                                timeout: TIMEOUT)

        if response.headers["status"].start_with? ERROR
          error = response.headers["status"].slice ERROR
        else
          data = response.parsed_response
        end
      rescue Net::OpenTimeout
        error = TIMEOUT_ERROR
      rescue
        error = CONNECT_ERROR
      end

      yield data, error
    end

    # Retrieve the property types from PlanetRent.  This requires the
    # use of the token associated with the supplied users account
    def property_types(user)
      error = nil

      if user.account?
        begin
          token = user.lettings_account.access_token.refresh!
          response =
            HTTParty.get("#{URL}#{API}property_types?access_token=#{token.access_token}",
                         timeout: TIMEOUT)
          @types = response.parsed_response["data"].map { |k, v| [v, k] }
        rescue Net::OpenTimeout
          error = TIMEOUT_ERROR
        rescue
          error = CONNECT_ERROR
        end

      end

      yield @types, error
    end

    # Retrieve the branch landlords from PlanetRent.  This requires the
    # use of the token associated with the supplied users account
    def landlords(user)
      error = nil

      if user.account?
        begin
          token = user.lettings_account.access_token.refresh!
          response =
            HTTParty.get("#{URL}#{API}get_all_landlords?access_token=#{token.access_token}",
                         timeout: TIMEOUT)
          @landlords = response.parsed_response["data"].map do |h|
             ["#{h['first_name']} #{h['last_name']}", h["reference"]]
          end
        rescue Net::OpenTimeout
          error = TIMEOUT_ERROR
        rescue
          error = CONNECT_ERROR
        end

      end

      yield @landlords, error
    end

    def get_property_link(plot)
      return unless plot.listing.live?
      "#{URL}/show_spaciable_property?other_ref=#{plot.listing_other_ref}"
    end

    # Get the planet rent authorizarion url
    def authorize_url(state)
      oauth2_client.auth_code.authorize_url(redirect_uri: CALLBACK, state: state.nonce)
    end

    # Use the code to get a token
    def token(code)
      token = error = nil

      begin
        token = oauth2_client.auth_code.get_token code, redirect_uri: CALLBACK
      rescue
        error = "Authorisation has been denied"
      end

      yield token, error
    end

    # create and returm a refreshed OAuth2::AccessToken
    def refresh_token(params)
      begin
        token = OAuth2::AccessToken.from_hash oauth2_client, params
        token = token.refresh! # unusually for a ! it does NOT change itself
      rescue => e
        error = e.message
      end

      yield token, error
    end

    private

    def oauth2_client
      OAuth2::Client.new(ID, SECRET, site: URL)
    end
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable all
