@javascript @poke
Feature: Dashboard
  As a homeowner
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Dashboard
    Given I am logged in as a homeowner want to download my documents
    And FAQ metadata is available
    And there is an appliance with a guide
    And there are faqs
    And there are contacts
    And there are how-tos
    When I navigate to the dashboard
    Then I see the recent homeowner contents
    When I the plot has a postal number
    Then I see the dashboard address reformatted

  Scenario: Prefix and Password
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    When I navigate to the dashboard
    Then I see the plot number as postal number
    When I change my homeowner password
    Then I should be logged out of homeowner

  Scenario: Savings and Referrals
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    And the developer has enabled savings
    And the developer has enabled referrals
    And there are how-tos
    When I navigate to the dashboard
    Then I see no referral link
    And I see no savings link
    Given the developer has a custom tile for savings
    And the developer has a custom tile for referrals
    When I navigate to the dashboard
    Then I see the savings
    And I see the referral link
    And I only see three articles

  Scenario: No Referrals
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    And the developer has not enabled referrals
    When I navigate to the dashboard
    Then I see no referral link

  Scenario: Refer a Friend
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    And the developer has enabled referrals
    And the developer has a custom tile for referrals
    When I refer a friend
    Then I should see the referral has been sent
    When I accept the referral
    Then I should see that my details have been confirmed
    And the Spaciable Admin should receive an email containing my details

  Scenario: Custom link
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    And the development has a custom link tile
    Then I can see the custom link tile

  Scenario: Inactive Feature
    Given I have created and logged in as a homeowner user
    And FAQ metadata is available
    And the development has enabled snagging
    And the development has set a snagging tile
    Then I should not see the snagging tile
    Given there is a estimated move in date in the past
    Then I should see the snagging tile
    When the snagging duration is past
    Then I should not see the snagging tile


