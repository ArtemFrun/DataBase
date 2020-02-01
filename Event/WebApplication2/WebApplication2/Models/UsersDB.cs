
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication2.Models
{
    public class UsersDB
    {

        string connectionString = @"Data Source=DESKTOP-6CP489Q\SQLEXPRESS;Initial Catalog=Events;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False";

        public void AddUser (Users user)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("AddUser", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Name", user.Name);
                    cmd.Parameters.AddWithValue("@Surname", user.Surname);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
            catch
            {
                throw;
            }
        }

        public Users GetUser(int id)
        {
            try
            {
                Users user = new Users();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("UserInfo", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id", id);
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                    {
                        user.Name = rdr["Name"].ToString();
                       // user.Surname = rdr["Surname"].ToString();
                    }
                    return user;
                }
            }
            catch
            {
                throw;
            }
        }

    }
}
