class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    add_user!(data)
    super(data)
  end
  def track_event(data)
    add_user!(data)
    transfer!(data)
    super(data)
  end

  private

  def add_user!(data)
    return if RequestStore.store[:current_user].nil? && RequestStore.store[:current_resident].nil?

    data[:userable_id] = RequestStore.store[:current_user] ?
                         RequestStore.store[:current_user].id :
                         RequestStore.store[:current_resident].id
    data[:userable_type] = RequestStore.store[:current_user] ? "User" : "Resident"
  end

  # Transfer any property attributes that match an Ahoy::Event
  # attribute from the properties to the data hash. This means
  # the field (e.g plot_id) gets put into the event.plot_id
  # field rather than into the properties column as json data
  def transfer!(data)
    Ahoy::Event.new().attributes.each do |property, _|
      property_sym = property.to_sym
      puts property_sym
      next unless data[:properties][property_sym]

      data[property_sym] = data[:properties][property_sym]
      data[:properties].delete(property_sym)
    end
  end

end

# set to true for JavaScript tracking
Ahoy.api = false

# better user agent parsing
Ahoy.user_agent_parser = :device_detector

# better bot detection
Ahoy.bot_detection_version = 2

#Ahoy.user_method = ->(controller) { controller.ahoy_user }
