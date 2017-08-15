Feature: Documents
  As a CF Admin
  I want to add our clients documents
  So that we can provide information to home owners about their plot

  Scenario: Developer Development
    Given I am logged in as an admin
    And there is a developer with a development
    And there is a plot
    And I navigate to the development
    When I upload a document using plot_name plot
    Then I should see the created plot_name plot document
    When I upload a document plot_name that does not match a plot
    Then I should see a plot_name plot document error

  Scenario: Division Development
    Given I am logged in as an admin
    And there is a division plot
    And I navigate to the division development
    When I upload a document using division_plot_name plot
    Then I should see the created division_plot_name plot document
    When I upload a document division_plot_name that does not match a plot
    Then I should see a division_plot_name plot document error

  Scenario: Phase
    Given I am logged in as an admin
    And there is a phase plot
    And there are private plot documents
    When I navigate to the development
    Then I should see the number of private documents
    And I navigate to the phase
    When I upload a document using phase_plot_name plot
    Then I should see the created phase_plot_name plot document
    When I upload a document phase_plot_name that does not match a plot
    Then I should see a phase_plot_name plot document error

  Scenario: Rename
    Given I am logged in as a CF Admin
    And there is a plot
    And I navigate to the development
    When I upload a document and rename it
    Then I should see the renamed document
