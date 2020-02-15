@poke
Feature: Developers
  As a CF Admin
  I want to add manufacturers
  So that I can use them when I create a new finish

  Scenario: Create manufacturer
    Given I am logged in as an admin
    And there is a finish category
    And there is a finish type
    When I create a finish manufacturer
    Then I should be required to enter a finish type
    Then I should see the created finish manufacturer
    When I update the finish manufacturer
    Then I should see the updated finish manufacturer

  Scenario Outline: Non CF Admins should not see Finish manufacturers
    Given I am logged in as a <role>
    Then I should not see finish manufacturers
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

  Scenario Outline: CAS Admins can CRUD Finish Manufacturers
    Given I am logged in as a <role> with CAS
    And there is a <role> finish category
    And there is a <role> finish type
    When I create a finish manufacturer
    Then I should be required to enter a finish type
    Then I should see the created finish manufacturer
    When I update the finish manufacturer
    Then I should see the updated finish manufacturer
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

