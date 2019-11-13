using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using FormValidation.Models;

// For more information on enabling MVC for empty projects, visit http://go.microsoft.com/fwlink/?LinkID=397860

namespace FormValidation.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(Person person)
        {
            if (!string.IsNullOrEmpty(person.PostalCode) && !person.PostalCode.StartsWith("5"))
                ModelState.AddModelError("PostalCode", "Kod pocztowy nie jest z Wrocławia");
            // Oglądamy zawartość ModelState pod debuggerem
            if (ModelState.IsValid)
            {
            }
            else
            {
            }
            return View();
        }
    }
}
