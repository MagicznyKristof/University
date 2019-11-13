using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace FormValidation.Models
{
    public class Person
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Podaj swoje imię")]
        public string FirstName { get; set; }
        [Required(ErrorMessage = "Podaj swoje nazwisko")]
        public string LastName { get; set; }
        [Required(ErrorMessage = "Podaj swój e-mail")]
        [RegularExpression(".+\\@.+\\..+", ErrorMessage = "Podany e-mail jest niepoprawny")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Podaj kod pocztowy")]
        [RegularExpression("[0-9]{2}-[0-9]{3}", ErrorMessage = "Podany kod pocztowy jest niepoprawny")]
        [Display(Name = "Kod pocztowy")]
        public string PostalCode { get; set; }
    }
}
