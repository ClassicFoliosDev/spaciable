Feature: My Home Library Documents
  As a homeowner
  I want to be able to upload documents related to the home I have purchased
  So that I can find all my documents in one place

  @javascript
  Scenario:
    Given I am logged in as a homeowner
    When I upload private documents
    Then I should see my private documents

    When I delete a private document
    Then I should no longer see the private document

    When I edit a private document
    Then I should see my updated private document
