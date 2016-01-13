using OpenQA.Selenium;
using System;

namespace ContosoUniversity.Web.SeFramework
{
    public class DepartmentsPage
    {
        public static void GoTo()
        {
            Driver.Instance.Navigate().GoToUrl("http://" + Driver.BaseAddress + "/Department");
        }

        public static string Name
        {
            get
            {
                var title = Driver.Instance.FindElement(By.TagName("h2"));
                if (title != null)
                    return title.Text;
                return String.Empty;
            }
        }

        public static bool DoesDepartmentExistWithName(string name)
        {
            var bodyTag = Driver.Instance.FindElement(By.TagName("body"));

            return bodyTag.Text.Contains(name);
        }
    }
}
