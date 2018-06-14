@javascript
Feature: Terms and Conditions
  As a site user
  I must see information about cookies
  To understand how the site uses cookies and what I can do with them

  Scenario:  Homeowner
    Given I am logged in as a homeowner
    Then I should see the cookie pop-up
    When I log out as a homeowner
    And I log in as a homeowner
    Then I should see the cookie pop-up
    When I accept the cookies
    And I log out as a homeowner
    And I log in as a returning homeowner
    Then I should no longer see the cookie pop-up

  Scenario: Admin
    Given I am logged in as a CF Admin
    Then I should see the cookie pop-up
    When I log out as a an admin
    And I log in as a CF admin
    Then I should see the cookie pop-up
    When I accept the cookies
    And I log out as a an admin
    And I log in as a CF admin
    Then I should no longer see the cookie pop-up
