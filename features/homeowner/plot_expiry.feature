@javascript @poke
Feature: Homeowner Plot Expiry
  As a homeowner
  When my plot expires
  Then my account is restricted

  Scenario: Fixflo Expiry
    Given I am logged in as a homeowner on a plot that will expire
    And the development has set a maintenance link
    Then I should see the maintenance link
    Given the completion release date is set
    And the date is after completion release date plus validity
    But the date is before extended access
    Then I should not see the maintenance link

  Scenario: Expired Branding
    Given I am logged in as a homeowner on a plot that will expire
    And the development has branding
    Then I should see the development branding
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then I should see the expired branding

  Scenario: Notifications and Emails
    Given I am logged in as a homeowner on a plot that will expire
    And I have enabled developer emails
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when a cf admin sends a notification
    Then I will receive an email
    And I will receive a notification
    Then when a non cf admin sends a notification
    Then I will not receive an email
    And I will not receive a notification

  Scenario: Contacts
    Given I am logged in as a homeowner on a plot that will expire
    And I have enabled developer emails
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when a cf admin creates a contact
    Then I will not receive an email
    And I will not have any notifications
    And I cannot see the contact
    Given there is another plot on my phase that is not expired
    When a non cf admin creates a contact
    When I will not receive a notification email
    And I will not have any notifications
    And I cannot see the contact
    When I log in as a resident on the live plot
    Then I can see a notification
    And I can see both contacts
    And I will have received an email

  Scenario: Documents
    Given I am logged in as a homeowner on a plot that will expire
    And I have enabled developer emails
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when a cf admin creates a document
    Then I will receive an email
    And I will receive a notification
    And I can see the document
    Given there is another plot on my phase that is not expired
    Then when a non cf admin creates a document
    Then I will not receive a notification email
    And I will not receive a notification
    And I cannot see the new document
    When I log in as a resident on the live plot
    Then I can see a notification
    And I can see both documents
    And I will have received an email

  Scenario: FAQs
    Given I am logged in as a homeowner on a plot that will expire
    And I have enabled developer emails
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when a cf admin creates a FAQ
    Then I will not receive an email
    And I will not have any notifications
    And I cannot see the FAQ
    Given there is another plot on my phase that is not expired
    Then when a non cf admin creates an FAQ
    Then I will not receive a notification email
    And I will not have any notifications
    And I cannot see the new FAQ
    When I log in as a resident on the live plot
    Then I can see a notification
    And I can see both FAQs
    And I will have received an email

  Scenario: Videos
    Given I am logged in as a homeowner on a plot that will expire
    And I have enabled developer emails
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when a cf admin creates a video
    Then I cannot see the video
    Given there is another plot on my phase that is not expired
    Then when a non cf admin creates a video
    Then I cannot see the new video
    When I log in as a resident on the live plot
    Then I can see both videos

  Scenario: Private documents
    Given I am logged in as a homeowner on a plot that will expire
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when I am on the private documents page
    Then I can no longer upload private documents

  Scenario: Invite residents
    Given I am logged in as a homeowner on a plot that will expire
    Given the completion release date has been set
    And the date is after completion release date plus validity
    And the date is after extended access
    Then when I am on the my account page
    Then I can no longer invite other residents to my plot
    Given there is another resident on my plot
    Then I can no longer delete residents from my plot