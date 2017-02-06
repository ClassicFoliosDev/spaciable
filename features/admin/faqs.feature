@javascript @slow
Feature: FAQs
  As an Admin
  I want to CRUD FAQs at different levels in the resource tree
  So that homeowners can see relavent FAQs for their plot

  Scenario: CF Admin
    Given I am a CF Admin and I want to manage FAQs
    When I create a FAQ for a Developer
    Then I should see the created Developer FAQ
    When I update the Developer FAQ
    Then I should see the updated Developer FAQ
    When I delete the Developer FAQ
    Then I should no longer see the Developer FAQ

    When I create a FAQ for a Division
    Then I should see the created Division FAQ

    When I create a FAQ for a Development
    Then I should see the created Development FAQ

    When I create a FAQ for a (Division) Development
    Then I should see the created (Division) Development FAQ

  Scenario: Developer Admin
    Given I am a Developer Admin and I want to manage FAQs
    When I create a FAQ for a Developer
    Then I should see the created Developer FAQ
    When I update the Developer FAQ
    Then I should see the updated Developer FAQ
    When I delete the Developer FAQ
    Then I should no longer see the Developer FAQ

    When I create a FAQ for a Division
    Then I should see the created Division FAQ

    When I create a FAQ for a Development
    Then I should see the created Development FAQ

    When I create a FAQ for a (Division) Development
    Then I should see the created (Division) Development FAQ

  Scenario: Division Admin
    Given I am a Division Admin and I want to manage FAQs
    And my Divisions Developer has FAQs
    Then I should only be able to see the Developer FAQs for my Division

    When I create a FAQ for a Division
    Then I should see the created Division FAQ
    When I update the Division FAQ
    Then I should see the updated Division FAQ

    When I create a FAQ for a (Division) Development
    Then I should see the created (Division) Development FAQ

  Scenario: Development Admin
    Given I am a Development Admin and I want to manage FAQs
    And my Developments Developer has FAQs
    Then I should only be able to see the Developer FAQs for my Development
    When I create a FAQ for a Development
    Then I should see the created Development FAQ
    When I update the Development FAQ
    Then I should see the updated Development FAQ

  Scenario: (Division) Development Admin
    Given I am a (Division) Development Admin and I want to manage FAQs
    And my (Division) Developments Developer has FAQs
    And my (Division) Developments Division has FAQs
    Then I should only be able to see the Developer FAQs for my (Division) Development
    And I should only be able to see the Division FAQs for my (Division) Development
    When I create a FAQ for a (Division) Development
    Then I should see the created (Division) Development FAQ
    When I update the (Division) Development FAQ
    Then I should see the updated (Division) Development FAQ
