using MvcExample.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MvcExample.Services
{
    public interface IPersonRepository
    {
        IEnumerable<Person> GetAll();
        Person GetById(int id);
    }
    public class PersonRepositoryIM : IPersonRepository
    {
        List<Person> _persons;

        public PersonRepositoryIM()
        {
            _persons = new List<Person>
            {
                new Person { Id = 1, FirstName = "Jan", LastName = "Kowalski", Address = "ul. Trawiasta 10" },
                new Person { Id = 2, FirstName = "Agata", LastName = "Zielony", Address = "ul. Koszykowa 12" },
                new Person { Id = 3, FirstName = "Ewa", LastName = "Szumska", Address = "ul. Zaciszna 3" }
            };
        }
        public IEnumerable<Person> GetAll()
        {
            return _persons;
        }

        public Person GetById(int id)
        {
            foreach (var p in _persons)
                if (p.Id == id)
                    return p;
            return null;
        }
    }
}
