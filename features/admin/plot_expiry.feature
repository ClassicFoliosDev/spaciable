@javascript @slow
Feature: Admin Plot Expiry
  As an admin
  When all plots expire on a phase/development/division/developer
  Then my abilities are restricted

  Scenario: Plot
    Given there are plots that have expired
    And I am logged in as a cf admin
    Given I am on the plot page
    Then I do not see a message telling me the plot is expired
    And I can CRUD documents
    And I can update the the build progress of that plot
    And I can update the completion date of that plot
    And I can add a resident to the plot
    And I can preview the plot
    Given I am logged in as a development admin
    Given I am on the plot page
    Then I see a message telling me the plot is expired
    And I can no longer CRUD documents
    And I can no longer update the build progress of that plot
    And I can no longer update the completion date of that plot
    And I can no longer add a resident to the plot
    And I can no longer preview the plot

  Scenario: Some phase plots expired
    Given there are plots that have expired
    And there are plots that have not expired
    Given I am logged in as a development admin
    Given I am on the phase page
    Then I see a message telling me some plots have expired on the phase
    And I can CRUD documents
    And there is a message saying documents will not be visible on expired plots
    And I can CRUD contacts
    And there is a message saying contacts will not be visible on expired plots

  Scenario: All phase plots expired
    Given there are plots that have expired
    And I am logged in as a cf admin
    Given I am on the phase page
    Then I do not see a message telling me the phase is expired
    And I can CRUD documents
    And I can CRUD contacts
    Given I am logged in as a development admin
    Given I am on the phase page
    Then I see a message telling me the phase has expired
    And I can no longer CRUD documents
    And I can no longer CRUD contacts

  Scenario: Some development plots expired
    Given there are plots that have expired
    And FAQ metadata is available
    And there are plots that have not expired
    Given I am logged in as a development admin
    Given I am on the development page
    Then I see a message telling me some plots have expired on the development
    And I can CRUD documents
    And there is a message saying documents will not be visible on expired plots
    And I can CRUD contacts
    And there is a message saying contacts will not be visible on expired plots
    And I can CRUD faqs
    And there is a message saying faqs will not be visible on expired plots
    And I can CRUD videos
    And there is a message saying videos will not be visible on expired plots

  Scenario: All development plots expired
    Given there are plots that have expired
    And FAQ metadata is available
    And I am logged in as a cf admin
    Given I am on the development page
    Then I do not see a message telling me the development is expired
    And I can CRUD documents
    And I can CRUD contacts
    And I can CRUD faqs
    And I can CRUD videos
    Given I am logged in as a development admin
    Given I am on the development page
    Then I see a message telling me the development has expired
    And I can no longer CRUD documents
    And I can no longer CRUD contacts
    And I can no longer CRUD faqs
    And I can no longer CRUD videos

  Scenario: Some division plots are expired
    Given there are plots that have expired
    And FAQ metadata is available
    And there are plots that have not expired
    Given I am logged in as a developer admin
    Given I am on the division page
    Then I do not see a message telling me some plots have expired on the division
    And I can CRUD documents
    And there is a message saying documents will not be visible on expired plots
    And I can CRUD contacts
    And there is a message saying contacts will not be visible on expired plots
    And I can CRUD faqs
    And there is a message saying faqs will not be visible on expired plots

  Scenario: All division plots expired
    Given there are plots that have expired
    And FAQ metadata is available
    And I am logged in as a cf admin
    Given I am on the division page
    Then I do not see a message telling me the division is expired
    And I can CRUD documents
    And I can CRUD contacts
    And I can CRUD faqs
    Given I am logged in as a developer admin
    Given I am on the division page
    And I can no longer CRUD documents
    And I can no longer CRUD contacts
    And I can no longer CRUD faqs

  Scenario: Some developer plots are expired
    Given there are plots that have expired
    And FAQ metadata is available
    And there are plots that have not expired
    Given I am logged in as a developer admin
    Given I am on the developer page
    Then I do not see a message telling me some plots have expired on the developer
    And I can CRUD documents
    And there is a message saying documents will not be visible on expired plots
    And I can CRUD contacts
    And there is a message saying contacts will not be visible on expired plots
    And I can CRUD faqs
    And there is a message saying faqs will not be visible on expired plots

  Scenario: All developer plots expired
    Given there are plots that have expired
    And FAQ metadata is available
    And I am logged in as a cf admin
    Given I am on the developer page
    Then I do not see a message telling me the developer is expired
    And I can CRUD documents
    And I can CRUD contacts
    And I can CRUD faqs
    Given I am logged in as a developer admin
    Given I am on the developer page
    Then I see a message telling me the developer has expired
    And I can no longer CRUD documents
    And I can no longer CRUD contacts
    And I can no longer CRUD faqs
    And I can no longer use the feedback feature
