using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FirstExample.Services
{
    public interface IGreeter
    {
        string SayHello();
    }
    public class Greeter : IGreeter
    {
        public string SayHello()
        {
            return "Hello!";
        }

    }
}
