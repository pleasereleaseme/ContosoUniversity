using ContosoUniversity.Web.SeFramework;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace ContosoUniversity.Web.AutoTests
{
    [TestClass]
    public class DepartmentTests : ContosoTest
    {
        [TestMethod]
        public void Can_Navigate_To_Departments()
        {
            DepartmentsPage.GoTo();
            Assert.AreEqual(DepartmentsPage.Name, "Departments");
        }

        [TestMethod]
        public void Can_Create_Department()
        {
            var departmentName = Guid.NewGuid().ToString();

            NewDepartmentPage.GoTo();
            NewDepartmentPage.CreateDepartment(departmentName)
                .WithBudget(13000)
                .WithStartDate(DateTime.Now)
                .WithAdministrator("Kapoor")
                .Create();

            Assert.IsTrue(DepartmentsPage.DoesDepartmentExistWithName(departmentName));
        }
    }
}
