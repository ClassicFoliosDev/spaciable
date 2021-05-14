@javascript @poke
Feature: Dashboard
  As an admin user
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Empty dashboard
    Given I am logged in as an admin
    When I navigate to the dashboard
    Then I see analytic charts

  Scenario: Dashboard with content
    Given I am logged in as a Developer Admin
    And there is a phase plot with a resident
    And there is a room
    And there are faqs
    And there are documents
    And there is an appliance manufacturer
    And there is an appliance with manual
    And there is an appliance with a guide
    And there are notifications
    When I navigate to the dashboard
    Then I see the recent contents

  Scenario: Help file
    Given I am logged in as an admin
    And I have run the settings seeds
    When I visit the settings page
    And I upload a help file
    Then I see the help file has been uploaded
    When I navigate to the help page
    Then I see a link to the PDF help file
