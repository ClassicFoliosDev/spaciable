Feature: Residents
  As an admin user
  I want to see a list / show view for residents
  So I can work out which development a resident belongs to

  Scenario: Residents
    Given I am logged in as an admin
    And there is a phase plot with a resident
    When I navigate to the residents view
    Then I see a list of residents
    And I can see an invidividual resident


