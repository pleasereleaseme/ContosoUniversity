using ContosoUniversity.Web.SeFramework;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ContosoUniversity.Web.AutoTests
{
    [TestClass]
    public class ContosoTest
    {
        [TestInitialize]
        public void Init()
        {
            Driver.Initialize();
        }

        [TestCleanup]
        public void Cleanup()
        {
            Driver.Close();
        }
    }
}
