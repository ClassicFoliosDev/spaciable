@javascript @poke
Feature: Homeowner Account
  As a homeowner
  I want to manage my account
  So that I can set my preferences

  # Some account tests moved to legal -> email notifications

  Scenario: Manage resident account
    Given I am a Development Admin wanting to assign a new resident to a plot
    And FAQ metadata is available
    And the developer has enabled services
    And a CF admin has configured a video link
    When I assign a new resident to a plot
    And I log out as a an admin
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the communication preferences page
    And when I click next
    Then I am redirected to the welcome home page
    And when I click next
    Then I should be redirected to the intro video page
    And when I click next
    Then I should be redirected to the services page
    When I select no services
    Then I should be redirected to the homeowner dashboard
    And I can see the intro video link in my account
    When I add another resident
    Then I should see the resident has been added
    When I add a homeowner resident
    Then I should see the homeowner resident has been added
    When I add another resident
    Then I should see a duplicate plot resident error
    When I log out as a homeowner
    And I visit the new invitation accept page
    And I accept the invitation as a homeowner
    And I should see be able to view My Account
    Then I can not add or remove residents
    When I log out as a homeowner
    And I log back in as the first homeowner
    And I should see be able to view My Account
    And I remove the additional resident
    Then I see the resident has been hard removed

  Scenario: Manage resident account - intro video disabled, services enabled
    Given I am a Development Admin wanting to assign a new resident to a plot
    And FAQ metadata is available
    And the developer has enabled services
    And a CF admin has disabled the intro video
    When I assign a new resident to a plot
    And I log out as a an admin
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the communication preferences page
    And when I click next
    Then I am redirected to the welcome home page
    And when I click next
    Then I should be redirected to the services page
    When I select no services
    Then I should be redirected to the homeowner dashboard

  Scenario: Manage resident account - intro video and services disabled
    Given I am a Development Admin wanting to assign a new resident to a plot
    And FAQ metadata is available
    And a CF admin has disabled the intro video
    When I assign a new resident to a plot
    And I log out as a an admin
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the communication preferences page
    And when I click next
    Then I am redirected to the welcome home page
    And when I click next
    Then I should be redirected to the homeowner dashboard
    And I cannot see the intro video link in my account

  Scenario: Account update
    Given I am logged in as a homeowner
    And FAQ metadata is available
    And the plot has an address
    Then I should see be able to view My Account
    When I update the account details
    Then I should see account details updated successfully
    When I remove notification methods from my account
    Then I should see account subscriptions removed successfully

  Scenario: Multiple residents
    Given I am logged in as a homeowner
    And FAQ metadata is available
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
    And FAQ metadata is available
    And a CF admin has configured a video link
    And I assign a new resident to a plot
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the communication preferences page
    And when I click next
    Then I am redirected to the welcome home page
    And when I click next
    Then I should be redirected to the intro video page
    And when I click next
    Then I should be redirected to the homeowner dashboard
    When I soft delete the plot residency
    And I log in as a Development Admin
    When I assign a new resident to a plot
    When I log in as an existing homeowner
    Then I should be redirected to the homeowner root page

  Scenario: Legacy homeowner
    Given there is a division with a development
    And FAQ metadata is available
    And there is a plot for the division development
    And I am a legacy homeowner
    When I log in with cookies
    Then the cookie should be set correctly
