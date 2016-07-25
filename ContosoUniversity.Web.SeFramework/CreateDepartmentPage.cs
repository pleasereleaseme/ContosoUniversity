using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;

namespace ContosoUniversity.Web.SeFramework
{
    public class CreateDepartmentPage
    {
        [FindsBy(How = How.Id, Using = "Name")]
        private IWebElement _name;
        [FindsBy(How = How.Id, Using = "Budget")]
        private IWebElement _budget;
        [FindsBy(How = How.Id, Using = "StartDate")]
        private IWebElement _startDate;
        [FindsBy(How = How.Id, Using = "InstructorID")]
        private IWebElement _administrator;
        [FindsBy(How = How.XPath, Using = "//input[@value='Create']")]
        private IWebElement _submit;

        public CreateDepartmentPage()
        {
            PageFactory.InitElements(Driver.Instance, this);
        }

        public static CreateDepartmentPage NavigateTo()
        {
            Driver.Instance.Navigate().GoToUrl("http://" + Driver.BaseAddress + "/Department/Create");

            return new CreateDepartmentPage();
        }
        public string Name
        {
            set
            {
                _name.SendKeys(value);
            }
        }

        public decimal Budget
        {
            set
            {
                _budget.SendKeys(value.ToString());
            }
        }

        public DateTime StartDate
        {
            set
            {
                // Workaround for unresolved situation where Windows 10 and Windows Server 2016 behaved differently when inputting dates
                var startDate = value.ToString();
#if DEBUG
                startDate = value.ToString("yyyy-MM-dd");
#endif       
                _startDate.SendKeys(startDate);
            }
        }

        public string Administrator
        {
            set
            {
                _administrator.SendKeys(value);
            }
        }

        public DepartmentsPage Create()
        {
            _submit.Click();

            return new DepartmentsPage();
        }
    }
}
