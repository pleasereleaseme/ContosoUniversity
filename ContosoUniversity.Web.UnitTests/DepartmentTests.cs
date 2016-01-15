using ContosoUniversity.Web.Models;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Data.Entity;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Moq;
using ContosoUniversity.Web.DAL;
using ContosoUniversity.Web.Controllers;
using System.Diagnostics.CodeAnalysis;

namespace ContosoUniversity.Web.UnitTests
{
    [ExcludeFromCodeCoverage]
    [TestClass]
    public class DepartmentTests
    {
        [TestMethod]
        public async Task Create()
        {
            var mockSet = new Mock<DbSet<Department>>();

            var mockContext = new Mock<SchoolContext>();
            mockContext.Setup(m => m.Departments).Returns(mockSet.Object);

            var controller = new DepartmentController(mockContext.Object);

            var department = new Department { DepartmentID = 999, Name = "Test", Budget = 1000, StartDate = DateTime.Today };
            await controller.Create(department);

            mockSet.Verify(m => m.Add(It.IsAny<Department>()), Times.Once());

            mockContext.Verify(m => m.SaveChangesAsync(), Times.Once());
        }

        [TestMethod]
        public async Task Delete()
        {
            var data = new List<Department>
            {
                new Department {DepartmentID = 1, Name = "Test1", Budget = 1001, StartDate = DateTime.Today.AddDays(1)},
                new Department {DepartmentID = 2, Name = "Test2", Budget = 1002, StartDate = DateTime.Today.AddDays(2)},
                new Department {DepartmentID = 3, Name = "Test3", Budget = 1003, StartDate = DateTime.Today.AddDays(3)},
                new Department {DepartmentID = 4, Name = "Test4", Budget = 1004, StartDate = DateTime.Today.AddDays(4)}
            }.AsQueryable();

            var mockSet = new Mock<DbSet<Department>>();
            mockSet.As<IQueryable<Department>>().Setup(m => m.Provider).Returns(data.Provider);
            mockSet.As<IQueryable<Department>>().Setup(m => m.Expression).Returns(data.Expression);
            mockSet.As<IQueryable<Department>>().Setup(m => m.ElementType).Returns(data.ElementType);
            mockSet.As<IQueryable<Department>>().Setup(m => m.GetEnumerator()).Returns(data.GetEnumerator());

            var mockContext = new Mock<SchoolContext>();
            mockContext.Setup(m => m.Departments).Returns(mockSet.Object);

            var controller = new DepartmentController(mockContext.Object);

            Department departmentToDelete = controller.GetAllDepartments().First();
            await controller.Delete(departmentToDelete);

            mockContext.Verify(m => m.SaveChangesAsync(), Times.Once());

            //Assert.AreEqual(3, controller.GetAllDepartments().Count);

        }
    }
}
