Feature: Legal emails
  As a homeowner
  I do not want to receive emails unless I have actively subscribed
  To protect my inbox from junk

  @javascript
  Scenario: Non-activated homeowner
    Given I am a homeowner
    Then I have not yet activated my account
    Given I am CF Admin wanting to send notifications to residents
    When I update the plot progress
    And I send a notification to the development
    Then no emails are sent to the unactivated homeowner

