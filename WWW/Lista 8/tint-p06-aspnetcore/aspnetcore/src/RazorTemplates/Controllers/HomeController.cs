using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace RazorTemplates.Controllers
{
    public class HomeController : Controller
    {
        private List<string> ourFriends = new List<string> { "Duży bank", "Znana firma", "Bogate wydawnictwo" };
        public HomeController()
        {

        }
        public IActionResult Index()
        {
            ViewData["OurFriends"] = ourFriends;
            return View();
        }

        public IActionResult About()
        {
            ViewData["OurFriends"] = ourFriends;
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Error()
        {
            return View();
        }
    }
}
