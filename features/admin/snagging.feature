@javascript @poke
Feature: Admin Snagging
  As an admin
  If snagging is enable for my development
  I want to see my snags

  Scenario: Admin with snagging, resident marked as resolved
    # This test has been set up so that the snagging duration has ended
    # so the functionality after snag duration ending is tested
    Given I am logged in as a development admin with snagging enabled
    And there are unresolved snags for a plot on my development
    Then I should see the snagging notification checkbox on my profile
    And I should see a notification next to the snagging link
    When I visit the snagging page
    Then I can see the snags that have been submitted
    Then I can view the snag details
    And I can add a comment
    When I mark the snag as resolved
    Then any resident of the plot can approve the resolved status
    And I am notified that the snag status have been approved
    And the resident is no longer able to submit snags

  Scenario: Admin with snagging disabled
    Given I am logged in as a development admin with snagging disabled
    When I visit the snagging page
    Then I cannot see any snags

  Scenario: Site admins cannot view snagging link
    Given I am logged in as a Site Admin
    Then I cannot see the snagging link

  Scenario: Admin with snagging, resident disputed
    Given I am logged in as a development admin with snagging enabled
    And there are unresolved snags for a plot on my development
    When I visit the snagging page
    Then I can see the snags that have been submitted
    Then I can view the snag details
    When I mark the snag as resolved
    Then a resident can dispute the resolved status
    And I am notified that the snag status has been rejected
    And the resident is able to add comments to the snag
