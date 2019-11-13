using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling MVC for empty projects, visit http://go.microsoft.com/fwlink/?LinkID=397860

namespace FormSimple.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index(string Imie, string Nazwisko)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(string Imie, string Nazwisko, string Adres)
        {
            return View();
        }
    }
}
