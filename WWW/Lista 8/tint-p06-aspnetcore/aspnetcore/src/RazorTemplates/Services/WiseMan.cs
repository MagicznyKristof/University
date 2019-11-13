using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RazorTemplates.Services
{
    public interface IWiseMan
    {
        string GetThought();
    }

    public class WiseMan : IWiseMan
    {
        public string GetThought()
        {
            string[] thoughts = new string[] {
                "Zabawne jak mało ważna jest Twoja praca, gdy prosisz o podwyżkę, a jak niesamowicie niezbędna dla ludzkości gdy prosisz o urlop...",
                "Pożyczaj od pesymistów - i tak nie wierzą, że oddasz.",
                "Sumienie - to co boli, gdy cała reszta ciebie czuje się świetnie.",
                "Nie ma co płakać nad rozlanym mlekiem, toż to nie piwo.",
                "Z wiekiem wzrasta szansa na dozgonną miłość.",
                "Dałbym tysiąc dolarów, żeby zostać milionerem.",
                "Żeby mi się chciało, tak jak mi się nie chce",
                "Pingwiny to jaskółki, które żarły po 18",
                "Człowiek bogaty ma pieniądze. Człowiek bardzo bogaty ma czas.",
                "Kaloria - mała wredna istota, która mieszka w twojej szafie i co noc zszywa ci coraz ciaśniej ubrania"
            };

            Random r = new Random();
            return thoughts[r.Next(10)];
        }
    }
}
