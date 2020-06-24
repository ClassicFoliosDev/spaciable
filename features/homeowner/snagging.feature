@javascript @poke
Feature: Homeowner Snagging
  As a homeowner
  If snagging is enable for my development
  I want to see my snags

  Scenario: Homeowner with Snagging
    Given I am logged in as a homeowner
    And FAQ metadata is available
    And my development has an admin with snagging notifications enabled
    Then I should see the Snagging page
    And I can add a snag to my plot
    And the relevant admins are notified
    When I visit the Snagging page
    Then I can see the snags submitted for my plot
    And I can click on a snag to view it in full
    And I can add a comment to the snag
    And the relevant admins are notified of my comment
    And I can edit the snag
    And I can add another snag
    Then I can see all of my snags
    And I can delete the snag
    And the relevant admins will be notified that I have deleted the snag