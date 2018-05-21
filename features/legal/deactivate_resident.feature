@javascript
Feature: Deactivate Resident
  As a homeowner
  I want to be able to close my account with Hoozzi
  So that my data is safe and I no longer receive emails

  Scenario: Homeowner
    Given I am logged in as a homeowner
    When I upload private documents
    Then I should see my private documents
    When I deactivate my account
    Then my account no longer exists
    And my documents no longer exist
    And I am no longer subscribed in mailchimp
    When I log in as a homeowner
    Then I see an error

