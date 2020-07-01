@javascript @poke
Feature: FAQs
  As an Admin
  I want to CRUD FAQs at different levels in the resource tree
  So that homeowners can see relevant FAQs for their plot

  Scenario: CF Admin
    Given I am a CF Admin and I want to manage FAQs
    And FAQ metadata is available
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
    And FAQ metadata is available
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
    And FAQ metadata is available
    And my Divisions Developer has FAQs
    And there is a division resident
    Then I should only be able to see the Developer FAQs for my Division
    When I create a FAQ for a Division
    Then I should see the created Division FAQ
    And I should see the faq resident has been notified
    When I update the Division FAQ
    Then I should see the updated Division FAQ
    When I create a FAQ for a (Division) Development
    Then I should see the created (Division) Development FAQ

  Scenario: Development Admin
    Given I am a Development Admin and I want to manage FAQs
    And FAQ metadata is available
    And my Developments Developer has FAQs
    Then I should only be able to see the Developer FAQs for my Development
    When I create a FAQ for a Development
    Then I should see the created Development FAQ
    When I update the Development FAQ
    Then I should see the updated Development FAQ

  Scenario: (Division) Development Admin
    Given I am a (Division) Development Admin and I want to manage FAQs
    And FAQ metadata is available
    And my (Division) Developments Developer has FAQs
    And my (Division) Developments Division has FAQs
    Then I should only be able to see the Developer FAQs for my (Division) Development
    And I should only be able to see the Division FAQs for my (Division) Development
    When I create a FAQ for a (Division) Development
    Then I should see the created (Division) Development FAQ
    When I update the (Division) Development FAQ
    Then I should see the updated (Division) Development FAQ

  Scenario: Cloned Default FAQs for new Developments
    Given I am logged in as an admin
    And FAQ metadata is available
    And default FAQs exist
    When I create a developer with development level FAQs
    Then I should not see default faqs for the developer
    When I create a development
    Then I should see default faqs for the development

  Scenario: Cloned Default FAQs for existing developer new Developments
    Given I am logged in as an admin
    And FAQ metadata is available
    And default FAQs exist
    When I create a developer
    Then I should see default faqs for the developer
    When I edit a developer faq
    And I create a development
    Then I should see no faqs for the development
    When I select development level FAQs
    Then I should see no faqs for the development
    When I create a second development
    Then I should not see the edited faq in the development faqs
    When I deselect development level FAQs
    And I create a third development
    Then I should see no faqs for the development
