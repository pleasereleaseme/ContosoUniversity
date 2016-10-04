using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using ContosoUniversity.Web.DAL;
using System.Data.Entity.Infrastructure.Interception;

namespace ContosoUniversity.Web
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            DbInterception.Add(new SchoolInterceptorTransientErrors());
            DbInterception.Add(new SchoolInterceptorLogging());
            Microsoft.ApplicationInsights.Extensibility.TelemetryConfiguration.Active.InstrumentationKey = System.Web.Configuration.WebConfigurationManager.AppSettings["iKey"];
        }
    }
}
