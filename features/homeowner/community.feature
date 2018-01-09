Feature: Community
  As a homeowner
  When I log into Hoozzi
  I want to see messages from other residents in my development

  @javascript
  Scenario:
    Given there is a phase plot with a resident
    And the developer has enabled development messages
    And I log in as a resident
    When I visit my community
    Then I can post a message
    And I log out as a homeowner
    Given there is another resident
    And I log in as a homeowner
    When I visit my community
    Then I can follow up an existing message
    And I can post a new message
    And I log out as a homeowner
    Given I log in as a resident
    When I visit my community
    Then I see all the messages

  Scenario: Archive
    Given there is a phase plot with a resident
    And the developer has enabled development messages
    And I log in as a resident
    And there is a message from four months ago
    When I visit my community
    Then I will not see the old message

  Scenario: Not enabled
    Given there is a phase plot with a resident
    And I log in as a resident
    Then I can not visit the community

