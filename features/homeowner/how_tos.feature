Feature: HowTos
  As a homeowner
  I want to see HowTos
  So that I revisit more frequently

  Scenario:
    Given I am logged in as a homeowner
    And there are how-tos
    And there is another phase plot for the homeowner
    Then I should see recent HowTos on my dashboard
    And I should not see the hidden HowTo
    When I go to read the HowTos
    Then I should see the HowTos for Around the home
    When I filter my HowTos by a different category
    Then I should only see the HowTos in the other category
    When I select a HowTo article
    Then I should see the HowTo details
    When I select a HowTo tag
    Then I should see a list of matching HowTos
