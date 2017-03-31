Feature: HowTos
  As a homeowner
  I want to read HowTos
  So that I revisit Hoozzi more frequently

  Scenario:
    Given I am logged in as a homeowner
    And there are how-tos
    Then I should see recent HowTos on my dashboard
    When I go to read the HowTos
    Then I should see the HowTos for Around the home

    When I filter my HowTos by a different category
    Then I should only see the HowTos in the other category
