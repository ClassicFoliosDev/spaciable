@javascript @slow
Feature: Add Download Reminder
  As a homeowner
  If I am using a mobile and have no downloaded the Spaciable app
  When I am on my homeowner dashboard then I see an app download reminder

  Scenario: Windows User
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    When I navigate to the dashboard
    Then I do not see an app download reminder

    @android_mobile
    Scenario: Android User
      Given I have created and logged in as a homeowner user
      And FAQ metadata is available
      When I navigate to the dashboard
      Then I see an app download reminder
      And the download button links to the default android app
      And the modal displays the default spaciable logo
      When I exit the modal
      Then I do not see an app download reminder
      When I go to another page
      Then I do not see an app download reminder
      Then I navigate to the dashboard
      Then I see an app download reminder
      Given my developer has branded app enabled
      When I navigate to the dashboard
      Then I see an app download reminder
      And the download button links to the default android app
      And the modal displays the default spaciable logo
      Given the branded app has been configured for my developer
      When I navigate to the dashboard
      Then I see an app download reminder
      And the download button links to the branded android app
      And the modal displays the branded developer icon
      When I click do not show again
      When I go to another page
      Then I navigate to the dashboard
      Then I do not see an app download reminder

    @apple_mobile
    Scenario: Apple User
      Given I have created and logged in as a homeowner user
      And FAQ metadata is available
      When I navigate to the dashboard
      Then I see an app download reminder
      And the download button links to the default apple app
      And the modal displays the default spaciable logo
      Given my developer has branded app enabled
      Given the branded app has been configured for my developer
      When I navigate to the dashboard
      Then I see an app download reminder
      And the download button links to the branded apple app
