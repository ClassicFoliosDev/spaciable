@javascript @poke
Feature: Brands
  As a CF Admin
  I want to create brands
  So I can use them to configure a developer's themed pages

  Scenario: Developer
    Given I am logged in as an admin
    And there is a developer
    When I create a brand
    Then I should see the created developer brand
    When I update the brand
    Then I should be able to preview the brand
    And I should see the updated developer brand
    When I remove an image from a brand
    Then I should see the updated developer brand without the image
    When I remove a login image from a brand
    Then I should see the developer login image is no longer present
    When I delete the developer brand
    Then I should see the developer brand deletion complete successfully

  Scenario: Division
    Given I am logged in as an admin
    And there is a developer with a division
    When I create a division brand
    Then I should see the created division brand
    When I update the brand
    Then I should be able to preview the brand
    And I should see the updated division brand
    When I remove an image from a brand
    Then I should see the updated division brand without the image
    When I delete the division brand
    Then I should see the division brand deletion complete successfully

  Scenario: Development
    Given I am logged in as an admin
    And there is a developer with a development
    When I create a development brand
    Then I should see the created development brand
    When I update the brand
    Then I should be able to preview the brand
    And I should see the updated development brand
    When I remove an image from a brand
    Then I should see the updated development brand without the image
    When I delete the development brand
    Then I should see the development brand deletion complete successfully

  Scenario: Developer Admin
    Given I am a Developer Admin
    Then I should not be able to see developer brands

  Scenario: Division Admin
    Given I am a Division Admin
    Then I should not be able to see division brands

  Scenario: Development Admin
    Given I am a Development Admin
    Then I should not be able to see development brands
