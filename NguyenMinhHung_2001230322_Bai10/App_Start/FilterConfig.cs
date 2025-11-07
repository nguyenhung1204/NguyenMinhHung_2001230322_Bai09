using System.Web;
using System.Web.Mvc;

namespace NguyenMinhHung_2001230322_Bai10
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
