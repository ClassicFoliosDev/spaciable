@javascript @poke
Feature: Lettings
  As a homeowner with multiple plots
  I want to be able to let plots

  Scenario: No Lettings
    Given I am a homeowner with multiple plots
    And FAQ metadata is available
    When I log in as homeowner
    When I have no lettable plots
    Then I shall not see a lettings button on my dashboard

  Scenario: Resident Lettings
    Given there are homeowner lettable phase plots
    And FAQ metadata is available
    Given the homeowner lettable phase plots have multiple occupation
    When I log in as homeowner "1" of lettable multiple occupation plots
    Then I shall see a lettings button on my dashboard
    When another resident is listing plots I occupy
    And I press my lettings button
    Then I shall see two options to set up a Planet Rent account
    And I shall see the details of the "1" lettings by other residents
    When I choose to let "self_managed"
    Then I shall get a message that my account has been set up
    And I shall be able to authorise my account
    When I authorise my account
    Then I shall see listings for all my plots
    And I shall see the details of the "1" lettings by other residents
    When I choose to list plot "2"
    Then I shall see plot "2" as listed on Planet Rent 
    When I choose to list plot "3"
    Then I shall see plot "3" as listed on Planet Rent
    When I log out as a homeowner
    When I log in as homeowner "3" of lettable multiple occupation plots
    And I press my lettings button
    And I shall see the details of the "3" lettings by other residents
    When I choose to let "management_service"
    Then I shall get a message that my account has been set up
    And I shall be able to authorise my account
    When I authorise my account
    Then I shall see listings for all my plots
    And I shall see the details of the "3" lettings by other residents
    When I have an expired token
    And I choose to list plot "4"
    Then I shall see plot "4" as listed on Planet Rent

    Scenario: Failures
    Given there are homeowner lettable phase plots
    And FAQ metadata is available
    Given the homeowner lettable phase plots have multiple occupation
    When I log in as homeowner "1" of lettable multiple occupation plots
    When I press my lettings button
    And I try and fail to let self_managed
    Then I should see an add user failure message
    When I choose to let "self_managed"
    Then I shall get a message that my account has been set up
    When I deny authorisation
    Then I am informed that Authorisation has been denied
    When I authorise my account
    Then I shall see listings for all my plots
    When I choose to list plot "2" with errors
    Then I shall see a listing error for plot "2"