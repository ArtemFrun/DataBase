using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WebApplication2.Models;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace WebApplication2.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : Controller
    {
        UsersDB usersDB = new UsersDB();

        [HttpGet]
        [Route("{id}")]
        public Users Get(int id)
        {
            return usersDB.GetUser(id);
        }

        [HttpPost]
        [Route("Create")]
        public void Post([FromBody]Users user)
        {
           usersDB.AddUser(user);
        }
    }
}
