using Microsoft.AspNetCore.Mvc;
using RazorTemplates.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RazorTemplates.ViewComponents
{
    public class ThoughtOfDayViewComponent : ViewComponent
    {
        private IWiseMan _wiseMan;

        public ThoughtOfDayViewComponent(IWiseMan wiseMan)
        {
            _wiseMan = wiseMan;
        }

        public IViewComponentResult Invoke()
        {
            var model = _wiseMan.GetThought();
            return View("Default", model);
        }
    }
}
