@javascript @poke
Feature: Development CSV
  As a CF Admin
  I want to upload a CSV to update multiple plots

  Scenario: CF Admin uploading CSV with invalid and valid input
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have plots
    When I navigate to the development page
    And I click on the Upload CSV tab
    Then I can download a CSV template
    And I can upload the test_csv.csv file
    Then I see the admin error messages
    And I see the admin notify messages
    And the valid admin plot has been updated
    And the invalid plot has not been updated

  Scenario: Client Admin
    Given I am logged in as a Development Admin
    And I have a developer with a development with unit types and a phase
    And I have plots
    When I navigate to the development page
    And I click on the Upload CSV tab
    Then I can download a CSV template
    And I can upload the client_admin_test.csv file
    Then I see the Developer admin error messages
    And I see the Development admin notify messages
    And the valid Developer admin plot has been updated
