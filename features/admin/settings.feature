Feature: Plots
  As a CF Admin
  I want to add a link to a video
  So that all users will see how wonderful the site is

  Scenario:
    Given I am logged in as an admin
    And I have run the settings seeds
    When I navigate to the settings page
    And I set the video link
    Then The video link has been configured

  # Other settings files are tested in the legal terms_and_conditions feature
