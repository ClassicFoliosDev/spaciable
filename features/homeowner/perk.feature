@poke @javascript
Feature: Perk
  As a homeowner
  If perks are available for my development
  I want to be able to activate my perk portal

  Scenario: Basic perks enabled
    Given I am logged in as an admin
    When I create a perks developer
    Then I should see the created perks developer
    When I update the perks developer with branded perks
    Then I should see the updated branded perks developer
    Given I am logged in as a homeowner on a perks plot
    Given my plot does not have a legal completion date
    Then I see the basic perks link
    Given my plot has a legal completion date in the future
    Then I see the basic perks link
    Given my plot has a legal completion date in the past
    Then I see the basic perks link
    When I sign up to perks then I see the branded perks link
    Given the developer has disabled perks
    Then I do not see the perks link

  Scenario: Premium perks enabled
    Given I am logged in as an admin
    When I create a perks developer
    And I create a perks development
    And I do not enter a premium licence duration
    Then I see an error telling me to enter a premium licence duration
    And I do not enter a premium licence quantity
    Then I see an error telling me to enter a premium licence quantity
    And I enter a valid premium licence duration and quantity
    Then I should see the created perks development
    Given I am logged in as a homeowner on a perks plot
    Given my plot does not have a legal completion date
    Then I see the perks coming soon link
    Given my plot has a legal completion date in the future
    Then I see the perks coming soon link
    Given my plot has a legal completion date of today
    And there are premium licences available
    And no other residents on my plot have activated premium perks
    Then I see the premium perks link
    And if another resident on my plot has activated premium perks then I see the basic perks link
    And if there are no premium licences available then I see the basic perks link
    And if I am a limited access user then I see the basic perks link
    When I sign up to perks then I see the default perks link
