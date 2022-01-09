@javascript @slow
Feature: Admin Users Additional Roles
  As an admin user with additional roles
  I want to access alternatives

Scenario: Developer Admin
  Given I am a Developer Admin
  And FAQ metadata is available
  And I have alternative Developer Admin roles
  When I upload a document for the additional developer
  Then I should see the created document
  And I should see the original filename
  When I update the developer's document
  Then I should see the updated additional developer document
  When I create another additional document
  Then I should see the document in the developer document list
  When I delete the document
  Then I should see that the deletion was successful for the developer document
  When I create a additional developer contact
  Then I should see the created contact
  When I create a additional phase contact
  Then I should see the created contact
  And I update the contact
  Then I should see the updated contact
  When I remove an image from a contact
  Then I should see the updated contact without the image
  When I delete the additional phase contact
  Then I should see the contact deletion complete successfully
  Then I should not be able to see additional developer brands
  When I create a FAQ for a additional Developer
  Then I should see the created additional Developer FAQ
  When I update the additional Developer FAQ
  Then I should see the updated additional Developer FAQ
  When I delete the additional Developer FAQ
  Then I should no longer see the additional Developer FAQ
  When I create a FAQ for a additional Division
  Then I should see the created additional Division FAQ
  When I create a FAQ for a additional Development
  Then I should see the created additional Development FAQ
  When I create a FAQ for a additional (Division) Development
  Then I should see the created additional (Division) Development FAQ

Scenario: Division Admin
  Given I am a Division Admin
  And I have alternative Division Admin roles
  And FAQ metadata is available
  And my additional Divisions Developer has FAQs
  And my additional Divisions Developer has FAQs
  Then I should not be able to see additional division brands
  Then I should only be able to see the Developer FAQs for my additional Division
  When I create a FAQ for a additional Division
  Then I should see the created additional Division FAQ
  And I should see the additional faq resident has been notified
  When I update the additional Division FAQ
  Then I should see the updated additional Division FAQ
  When I create a FAQ for a additional (Division) Development
  Then I should see the created additional (Division) Development FAQ
  When I create a additional division contact
  Then I should see the created contact
  When I create a additional division phase contact
  Then I should see the created contact
  And I update the contact
  Then I should see the updated contact
  When I remove an image from a contact
  Then I should see the updated contact without the image
  When I delete the additional division phase contact
  Then I should see the contact deletion complete successfully
  When I upload a document for the additional division
  Then I should see the created document
  And I should see the original filename
  When I update the document
  Then I should see the updated additional division document
  When I delete the document
  Then I should see that the deletion was successful for the document


Scenario: Development Admin
  Given I am a Development Admin
  And I have alternative Development Admin roles
  And FAQ metadata is available
  And my additional Developer has FAQs
  When I upload a document for the additional development
  Then I should see the created document
  And I should see the original filename
  When I update the document
  Then I should see the updated additional development document
  When I delete the document
  Then I should see that the deletion was successful for the document
  Then I should not be able to see additional development brands
  Then I should only be able to see the additional Developer FAQs for my Development
  When I create a FAQ for a additional Development
  Then I should see the created additional Development FAQ
  When I update the additional Development FAQ
  Then I should see the updated additional Development FAQ
