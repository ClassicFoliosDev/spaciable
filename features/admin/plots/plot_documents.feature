@poke @javascript
Feature: Documents
  As a CF Admin
  I want to add our clients documents
  So that we can provide information to home owners about their plot

  Scenario: Phase
    Given I am logged in as an admin
    And there is a phase plot
    And there are private plot documents
    When I navigate to the development
    And I navigate to the phase
    When I upload a document using phase_plot_name plot
    Then I should see the created phase_plot_name plot document
    And I should see the document resident has been notified
    When I upload a document phase_plot_name that does not match a plot
    Then I should see a phase_plot_name plot document error
    Given I have selected 10 documents per page
    When I edit a plot document
    Then I should be redirected to the plot document page
    And the plot document should be updated
    When I delete a plot document
    Then I should be redirected to the plot document page
    And the plot document should be deleted
