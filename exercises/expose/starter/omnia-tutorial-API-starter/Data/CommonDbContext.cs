using omnia_tutorial.Models;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace omnia_tutorial.Data
{
    public class CommonDbContext : DbContext
    {
        public CommonDbContext(DbContextOptions<CommonDbContext> options) : base(options)
        {
            var conn = (SqlConnection)Database.GetDbConnection();
            conn.AccessToken = new AzureServiceTokenProvider().GetAccessTokenAsync("https://database.windows.net/").Result;
        }

        public DbSet<ProductionData> ProductionData { get; set; }
    }
}
