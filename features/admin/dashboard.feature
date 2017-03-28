Feature: Dashboard
  As an admin user
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Empty dashboard
    Given I am logged in as an admin
    When I navigate to the dashboard
    Then I see blank recent contents

  Scenario: Dashboard with content
    Given I am logged in as an admin
    And there is a developer with a development
    And there is a unit type
    And there is a room
    And there are faqs
    And there is a document
    And I have an appliance with a guide
    And there is an appliance with manual
    And there are notifications
    When I navigate to the dashboard
    Then I see the recent contents

  # Scenario: Development admin
    # Given I am a Development Admin
    # And there is a plot
    # And there is a room
    # And there are faqs
    # And there is a document
    # And I have an appliance with a guide
    # And there is an appliance with manual
    # And there are notifications
    # When I navigate to the dashboard
    # Then I see the recent contents

