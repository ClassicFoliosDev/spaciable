@javascript @poke
Feature: Dashboard
  As a homeowner
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Dashboard
    Given I am logged in as a homeowner want to download my documents
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
    When I navigate to the dashboard
    Then I see the plot number as postal number
    When I change my homeowner password
    Then I should be logged out of homeowner

  Scenario: Services and Referrals
    Given I have created and logged in as a homeowner user
    And the developer has enabled services
    And the developer has enabled referrals
    And there are how-tos
    And there are services
    When I navigate to the dashboard
    Then I see the services
    And I see the referral link
    And I only see two articles

  Scenario: No Referrals
    Given I have created and logged in as a homeowner user
    And the developer has not enabled referrals
    When I navigate to the dashboard
    Then I see no referral link

  Scenario: Refer a Friend
    Given I have created and logged in as a homeowner user
    And the developer has enabled referrals
    When I refer a friend
    Then I should see the referral has been sent
    When I accept the referral
    Then I should see that my details have been confirmed
    And the Hoozzi Admin should receive an email containing my details

