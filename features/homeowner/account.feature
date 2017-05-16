Feature: HowTos
  As a homeowner
  I want to manage my account
  So that Hoozzi knows my preferences

  Scenario:
    Given I am logged in as a homeowner
    Then I should see be able to view My Account
    When I update the account details
    Then I should see account details updated successfully


