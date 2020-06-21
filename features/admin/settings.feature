@javascript @poke
Feature: Plots
  As a CF Admin
  I want to add a link to a video
  So that all users will see how wonderful the site is

  Scenario:
    Given I am logged in as an admin
    And I have run the settings seeds
    When I navigate to the global uploads page
    And I set the video link
    Then The video link has been configured

  Scenario:
    Given I am logged in as an admin
    And FAQ metadata is available
    When I navigate to the settings page
    Then I can select default FAQs for all countries
    And I can CRUD default FAQs for all countries

  # Other settings files are tested in the legal terms_and_conditions feature
