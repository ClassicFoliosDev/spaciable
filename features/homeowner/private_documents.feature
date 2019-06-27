@javascript @poke
Feature: My Home Library Documents
  As a homeowner
  I want to be able to upload documents related to the home I have purchased
  So that I can find all my documents in one place

  Scenario:
    Given I am logged in as a homeowner
    And there is another tenant on the homeowner plot
    When I upload private documents
    Then I should see my private documents

    When I delete a private document
    Then I should no longer see the private document

    When I edit a private document
    Then I should see my updated private document

    When I share a private document with tenants
    Then I should see the private document has been shared

    When I log out as a homeowner
    And I log in as a tenant
    Then I should see the shared private document

    When I upload private documents
    Then I should see my private documents

    When I delete a private document
    Then I should no longer see the private document

    When I edit a private document
    Then I should see my updated private document

    And I should not be able to share a private document