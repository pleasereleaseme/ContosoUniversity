Feature: Department
	In order to expand Contoso University
	As an administrator
	I want to be able to create a new Department

Scenario: New Department Created Successfully
	Given I am on the Create Department page
		And I enter a randomly generated Department name
		And I enter a budget of £1400
		And I enter a start date of today
		And I enter an administrator with name of Kapoor
	When I submit the form
	Then I should see a new department with the specified name
