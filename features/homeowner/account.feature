Feature: Homeowner Account
  As a homeowner
  I want to manage my account
  So that Hoozzi knows my preferences

  Scenario:
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    And I accept the invitation as a homeowner
    Then I should be redirected to the homeowner dashboard

  Scenario: With services
    Given I am a Development Admin wanting to assign a new resident to a plot
    And the developer has enabled services
    And I have seeded the database with services
    When I assign a new resident to a plot
    And I accept the invitation as a homeowner
    And I select my services
    Then My services have been selected

  Scenario: With services choose none
    Given I am a Development Admin wanting to assign a new resident to a plot
    And the developer has enabled services
    And I have seeded the database with services
    When I assign a new resident to a plot
    And I accept the invitation as a homeowner
    And I select no services
    Then I should be redirected to the homeowner dashboard

  Scenario: Account update
    Given I am logged in as a homeowner
    And the developer has enabled services
    And I have seeded the database with services
    Then I should see be able to view My Account
    When I update the account details
    Then I should see account details updated successfully
    When I remove services from my account
    Then I should see account subscriptions removed successfully

  Scenario: Without services
    Given I am logged in as a homeowner
    Then I should not see services in my account
    And I should not see services when I edit my account

  @javascript
  Scenario: Multiple residents
    Given I am logged in as a homeowner
    And There is a plot with many residents
    Then I should see the resident emails listed in my account
    When I show the plots
    And I switch to the second plot
    Then I should not see other resident emails listed in my account
    When I show the plots
    When I switch to the homeowner plot
    Then I should see the resident emails listed in my account
