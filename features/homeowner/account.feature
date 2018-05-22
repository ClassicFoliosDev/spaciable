@javascript
Feature: Homeowner Account
  As a homeowner
  I want to manage my account
  So that Hoozzi knows my preferences

  # Some account tests moved to legal -> email notifications

  Scenario: With services choose none
    Given I am a Development Admin wanting to assign a new resident to a plot
    And the developer has enabled services
    And a CF admin has configured a video link
    And I have seeded the database with services
    When I assign a new resident to a plot
    And I log out as a an admin
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the video introduction page
    When I select no services
    Then I should be redirected to the homeowner dashboard
    When I add another resident
    Then I should see the resident has been added
    When I add another resident
    Then I should see a duplicate plot resident error
    When I log out as a homeowner
    And I visit the invitation accept page
    And I accept the invitation as a homeowner
    And I should see be able to view My Account
    Then I can not add or remove residents
    When I log out as a homeowner
    And I log back in as the first homeowner
    And I should see be able to view My Account
    And I remove the additional resident
    Then I see the resident has been hard removed

  Scenario: Account update
    Given I am logged in as a homeowner
    And the developer has enabled services
    And the plot has an address
    And I have seeded the database with services
    Then I should see be able to view My Account
    When I update the account details
    Then I should see account details updated successfully
    When I remove services from my account
    Then I should see account subscriptions removed successfully
    And the email should include all my details

  Scenario: Without services
    Given I am logged in as a homeowner
    Then I should not see services in my account
    And I should not see services when I edit my account

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

  Scenario: Delete and recreate with soft delete (legacy)
    Given I am a Development Admin wanting to assign a new resident to a plot
    And a CF admin has configured a video link
    And I assign a new resident to a plot
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the video introduction page
    And I should be redirected to the homeowner dashboard
    When I soft delete the plot residency
    And I log in as a Development Admin
    When I assign a new resident to a plot
    When I log in as an existing homeowner
    Then I should be redirected to the homeowner dashboard

  Scenario: Legacy homeowner
    Given there is a division with a development
    And there is a plot for the division development
    And I am a legacy homeowner
    When I log in with cookies
    Then I should be on the "My Home" dashboard
    And the cookie should be set correctly
