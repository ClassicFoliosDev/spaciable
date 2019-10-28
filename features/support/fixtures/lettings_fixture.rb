# frozen_string_literal: true

module LettingsFixture
  module_function

  ID="d1f53c427900fd75b3b0c72f95c3275fa2d899183f305d8d1f947e10ed5fe757"
  SECRET="67787123d349b23f34bb3a96519a4cfe7848b62e0821c21ec6148a897ec439d5"
  URL="https://staging.deals.planetrent.co.uk"
  CODE="e6b436632d7cef438d15c408ee0d1be40a48f192860b87feee460ecbe928eb42"
  REDIRECT="https://spaciable.ngrok.io/users/auth/doorkeeper/callback"
  ACCESS_TOK="306abcd0aeca8534a3d0b2ff9631511ee1436671802e4b686d26926595deb274"
  REFRESH_TOK="a14d21a6481105dd5db94b5376541bb37b4a4663e3e72e15ca92eff424baeb28"

  OK = "200 OK"
  BAD_REQUEST = "400 Bad Request"
  CREATED = "201 Created"

  @@residents = []

  def create_letting_admins
    AdminUsersFixture.create_permission_resources
    [ 
      [:developer_admin, CreateFixture.developer], 
      [:division_admin, CreateFixture.division],
      [:development_admin, CreateFixture.development],
      [:site_admin, CreateFixture.development],
      [:development_admin, CreateFixture.division_development]
    ].each do |k,v|
      (1..2).each do |n|
        FactoryGirl.create(k, 
                           permission_level: v, 
                           password: lettings_users_password,
                           first_name: "#{k}#{n}",
                           last_name: "admin",
                           email: "#{v.to_s.delete(' ')+'.'+k.to_s}#{n}@#{developer_acronym}.com")
      end
    end
  end

  def create_developer_development_branch_admin
    AdminUsersFixture.create_permission_resources
    FactoryGirl.create(:developer_admin, 
                       permission_level: CreateFixture.developer, 
                       password: CreateFixture.admin_password,
                       lettings_management: User.lettings_managements.key(User.lettings_managements[:branch]))
  end

  def lettings_users_password
    "12345678"
  end

  def developer_acronym
    "HVD"
  end

  def developer_admins
    User.where(role: User.roles.key(User.roles[:developer_admin])).sort
  end

  def division_admins
    User.where(role: User.roles.key(User.roles[:division_admin])).sort
  end

  def developer_development_admins
    CreateFixture.developer.potential_branch_admins
  end

  def division_development_admins
    CreateFixture.division.potential_branch_admins
  end

  def token_request
    {
      "client_id"=>"#{ID}", 
      "client_secret"=>"#{SECRET}", 
      "code"=>"#{CODE}", 
      "grant_type"=>"authorization_code", 
      "redirect_uri"=>"#{REDIRECT}"
    }
  end

  def refresh_token
    {
      "client_id"=>"#{ID}", 
      "client_secret"=>"#{SECRET}", 
      "grant_type"=>"refresh_token", 
      "refresh_token"=> "#{REFRESH_TOK}"
    }
  end

  def token_headers
    {
      'Accept'=>'*/*', 
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
      'Content-Type'=>'application/x-www-form-urlencoded', 
      'User-Agent'=>'Faraday v0.12.1'
    }
  end

  def token_body
    {
      "access_token" => "#{ACCESS_TOK}",
      "token_type" => "bearer",
      "expires_in" => 7200,
      "refresh_token" =>"#{REFRESH_TOK}",
      "created_at" => Time.now.to_i
    }
  end

  def response_headers (status=OK)
    {
      "date"=>"#{Time.now.strftime('%a, %d %b %Y %H:%M:%S')} GMT", 
      "server"=>"Apache/2.4.18 (Ubuntu)", 
      "cache-control"=>"no-store", 
      "vary"=>"Origin", 
      "pragma"=>"no-cache", 
      "x-xss-protection"=>"1; mode=block", 
      "x-request-id"=>"4dc85d9e-f6dd-4027-9ff4-44f3f4366a92", 
      "x-frame-options"=>"SAMEORIGIN", 
      "x-runtime"=>"0.127310", 
      "x-content-type-options"=>"nosniff", 
      "x-powered-by"=>"Phusion Passenger Enterprise 5.2.2", 
      "etag"=>"W/\"052e5e9c2dbe7104f9733ddf227339b5\"", 
      "status"=>"#{status}", 
      "connection"=>"close", 
      "transfer-encoding"=>"chunked", 
      "content-type"=>"application/json; charset=utf-8"
    }
  end

  def oauth2_header
    {
      'Accept'=>'*/*', 
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
      'User-Agent'=>'Ruby'
    }
  end

  def post_header
      {
        'Accept'=>'application/json', 
        'Content-Type'=>'application/json'
      }
  end

  def get_property_types
    {
      "data"=>
      {
        "0"=>"house", 
        "1"=>"terraced", 
        "2"=>"end_terrace", 
        "3"=>"semi_detached", 
        "4"=>"detached", 
        "5"=>"mews", 
        "7"=>"flat", 
        "8"=>"flat", 
        "9"=>"studio", 
        "10"=>"maisonette", 
        "11"=>"maisonette", 
        "12"=>"bungalow", 
        "13"=>"terraced_bungalow", 
        "14"=>"semi_detached_bungalow", 
        "15"=>"detached_bungalow", 
        "20"=>"land", 
        "21"=>"detached_house", 
        "22"=>"town_house", 
        "23"=>"cottage", 
        "24"=>"chalet", 
        "27"=>"villa", 
        "30"=>"finca", 
        "43"=>"barn_conversion", 
        "45"=>"parking", 
        "50"=>"park_home", 
        "52"=>"farm", 
        "62"=>"longere", 
        "113"=>"county_house", 
        "118"=>"lodge", 
        "141"=>"houseboat", 
        "181"=>"business_park"
      }
    }
  end

  def plot_fields(plot)
    { 
      "address_1" => (plot.postal_number + " " + plot.building_name),
      "address_2" => plot.road_name,
      "postcode" => plot.postcode,
      "country" => "UK",   
      "town" => plot.city,
      "bathrooms" => "2",
      "bedrooms" => "3",
      "landlord_pets_policy" => "No Pets",
      "has_car_parking" => "true",
      "has_bike_parking" => "true",
      "property_type" => "0",
      "price" => "1000",
      "shared_accommodation" => "true",
      "notes" => "off-road parking",
      "summary" => "average"
    }
  end

  def get_property(plot)
    request = { 
      "access_token" => ACCESS_TOK,
      "property" => [{"other_ref" => "spaciable#{plot.id}"}]
    }

    plot_fields(plot).map do |k,v|
      request["property"][0][k] = v
    end

    request
  end

  def get_property_response(plot)
    {
      "data"=>[
        {
          "other_ref"=>"spaciable#{plot.id}", 
          "reference"=>"P64", 
          "status"=>true
        }
      ]
    } 
  end

def get_property_error_response(plot)
    {
      "data"=>[
        {
          "other_ref"=>"spaciabl#{plot.id}", 
          "status"=>false, 
          "errors"=>
          {
            "other_ref"=>["spaciable#{plot.id} property already exists on PlanetRent"]}
          }
        ]
    } 
  end

  def create_landlord (user, management)
    {
      "user" => {
        "first_name" => user.first_name,
        "last_name" => user.last_name,
        "email" => user.email,
        "restricted" => management
      }
    }
  end

  def create_landlord_response (user)
    {
      "data"=>
        {
          "reference"=>"L#{user.id}", 
          "username"=>"#{user.first_name}", 
          "restricted"=>false
      }
    }
  end  

  def create_landlord_failure_response
    {
      "errors"=>"Validation failed: First name can't be blank"
    }
  end  


  # create a listing for all plots
  def create_plot_listings (owner = Listing::owners.key(Listing::owners[:admin]))
    Plot.all.each do |plot|
      FactoryGirl.create(:listing, owner: owner, plot_id: plot.id)
    end
  end

  def create_multiple_residents
    return if Resident.all.count != 0
    @@residents.clear
    (1..3).each do |r|
      @@residents << FactoryGirl.create(:resident,
                                email: "resident#{r}@gmail.com",
                                password: HomeownerUserFixture.password,
                                first_name: "resident#{r}",
                                last_name: "Letwin",
                                ts_and_cs_accepted_at: Time.zone.now,
                                phone_number: HomeownerUserFixture.phone_num
                              )
    end
  end

  def create_multiple_resident_plot_occupation
    create_multiple_residents
    Plot.all.each do |p|
      @@residents.each do |r|
        next if PlotResidency.find_by(plot_id: p.id, resident_id: r.id).present?
        FactoryGirl.create(:plot_residency, plot_id: p.id, resident_id: r.id)
      end
    end
  end

  def residents
    @@residents
  end

  def account (resident)
    account = LettingsAccount.find_by(accountable_type: Resident.to_s, accountable_id: resident.id)
    return account unless account.nil?
    LettingsAccount.create(accountable_type: Resident.to_s, 
                           accountable_id: resident.id,
                           management: LettingsAccount::managements.key(LettingsAccount::managements[:self_managed]),
                           authorisation_status: LettingsAccount::authorisation_statuses.key(LettingsAccount::authorisation_statuses[:authorised])
                          ) do | account, success |
      return account if success
    end
  end

  def let_plot (plot, resident)
    Listing.where(plot_id: plot.id).update_all(lettings_account_id: account(resident).id)
  end

end
