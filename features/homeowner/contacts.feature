Feature: Homeowner Contacts
  As a homeowner
  I want to log into Hoozzi
  To look at the contact details for my developer

  Scenario:
    Given there is a division plot
    And there are division contacts
    And I have logged in as a resident and associated the division development plot
    When I visit the contacts page
    Then I should see the contacts for my plot
    And I should see contacts on the dashboard
