Feature: User navigation
  So that I can navigate the user area
  As a user
  I want to log in and navigate around

    Scenario: Login brings me to my user page
      When I log in as a user
      Then I should be on my user page

    Scenario: I can't view another user's page
      Given there is a user "Billy"
      When I am logged in as a user
      And I try to visit the user page for "Billy"
      Then I should be on my user page
      And I receive a not authorized message

    Scenario: I can go back to my page once I view an invoice
      Given I am logged in as a user "Bob"
      And there is a $5.00 invoice "Potatoes" for the user "Bob"
      And I am on my user page
      When I open the invoice for "Potatoes"
      And I click the back button
      Then I should be on my user page