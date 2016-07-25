using OpenQA.Selenium;
using System;

namespace ContosoUniversity.Web.SeFramework
{
    public class DepartmentsPage
    {
        public static DepartmentsPage NavigateTo()
        {
            Driver.Instance.Navigate().GoToUrl("http://" + Driver.BaseAddress + "/Department");

            return new DepartmentsPage();
        }

        public string Name
        {
            get
            {
                var title = Driver.Instance.FindElement(By.TagName("h2"));
                if (title != null)
                    return title.Text;
                return String.Empty;
            }
        }

        public bool DoesDepartmentExistWithName(string name)
        {
            var bodyTag = Driver.Instance.FindElement(By.TagName("body"));

            return bodyTag.Text.Contains(name);
        }
    }
}