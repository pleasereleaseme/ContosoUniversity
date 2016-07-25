using System;
using TechTalk.SpecFlow;
using ContosoUniversity.Web.SeFramework;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ContosoUniversity.Web.AutoTests
{
    [Binding]
    public class DepartmentSteps
    {
        private CreateDepartmentPage _createDepartmentPage;
        private DepartmentsPage _departmentsPage;
        private string _departmentName;

        [Given(@"I am on the Create Department page")]
        public void GivenIAmOnTheCreateDepartmentPage()
        {
            _createDepartmentPage = CreateDepartmentPage.NavigateTo();
        }

        [Given(@"I enter a randomly generated Department name")]
        public void GivenIEnterARandomlyGeneratedDepartmentName()
        {
            _departmentName = Guid.NewGuid().ToString();
            _createDepartmentPage.Name = _departmentName;
        }

        [Given(@"I enter a budget of £(.*)")]
        public void GivenIEnterABudgetOf(Decimal budget)
        {
            _createDepartmentPage.Budget = budget;
        }

        [Given(@"I enter a start date of today")]
        public void GivenIEnterAStartDateOfToday()
        {
            _createDepartmentPage.StartDate = DateTime.Now;
        }

        [Given(@"I enter an administrator with name of (.*)")]
        public void GivenIEnterAnAdministratorWithNameOf(string administrator)
        {
            _createDepartmentPage.Administrator = administrator;
        }

        [When(@"I submit the form")]
        public void WhenISubmitTheForm()
        {
            _departmentsPage = _createDepartmentPage.Create();
        }

        [Then(@"I should see a new department with the specified name")]
        public void ThenIShouldSeeANewDepartmentWithTheSpecifiedName()
        {
            Assert.IsTrue(_departmentsPage.DoesDepartmentExistWithName(_departmentName));
        }

        [BeforeScenario]
        public void Init()
        {
            Driver.Initialize();
        }

        [AfterScenario]
        public void Cleanup()
        {
            Driver.Close();
        }
    }
}